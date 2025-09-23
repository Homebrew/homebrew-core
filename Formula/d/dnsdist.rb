class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.0.tar.xz"
  sha256 "da30742f51aac8be7e116677cb07bc49fbea979fc5443e7e1fa8fa7bd0a63fe5"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cf4c5a925198b17d8e05253102dc9a9d2bd4bfeed81c097e0bb9d8c030165908"
    sha256 arm64_sequoia: "48fc229b93784bbbca86594932782b68c2d39a372c81852554566759c9e4fec4"
    sha256 arm64_sonoma:  "61ee746d8aa46239aecfd25d29178703a0b3ee0034d1883539b633658f3484ac"
    sha256 arm64_ventura: "defa6e917b47a72fb8fa70dbb4f0d606d03fe9f6c62c162dcd0d1cc956c653ae"
    sha256 sonoma:        "a61fd69f6a633ec9238689fb9ee3dc196c9c02d61a87e459943740deba4a8185"
    sha256 ventura:       "61ee04523f9d06aebcddc60e9478a8fc99a98c1d611091f3765383aebbd5b19f"
    sha256 arm64_linux:   "ecefdd743e4a38656412481a0d3f70d4bd5af9ca5b06d96cb29a76dd01b94b3b"
    sha256 x86_64_linux:  "6cfc27b694d6a3557b83c6bbdfe028429aacb3d442e0eac0882bfafaab7c5881"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  resource "PyYaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    venv = virtualenv_create(buildpath/"bootstrap", "python3")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
