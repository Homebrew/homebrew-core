class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.1.tar.xz"
  sha256 "144e2356d07d6577a570782a6f79f426125344221dbdc4ddaaa7f9d468d51900"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dfea90bdb98efc4b827ed4c32ea6efbb1417e57623120ea43ab97d4a3d1f22da"
    sha256 arm64_sequoia: "fc32d06a35b1611c4bb3ed43712359fc095d0c68b7772b9e48355728ce6494da"
    sha256 arm64_sonoma:  "8ed1785bf9262c314b75defbcf3fac20972d70f430fbfa1cb5765e416cdedd08"
    sha256 sonoma:        "d593835bf6940fa880d91beb34e8aa02e0ce0986abd9bdec8f3149882a2cee6c"
    sha256 arm64_linux:   "6b0d88620b7c47cc49ffa88da13b9ccf1eb7ab03c2511ad80fd67bde8a06a07b"
    sha256 x86_64_linux:  "1d32e7c0ec893b6233949e76ca6b9af53eec64290f506d93dfd6ec4ad9a5e0c4"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
