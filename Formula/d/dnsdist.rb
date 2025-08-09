class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.0.tar.xz"
  sha256 "da30742f51aac8be7e116677cb07bc49fbea979fc5443e7e1fa8fa7bd0a63fe5"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "549e116718c27d07ffb8d00d5138e45110cae374de43f615ed0322cd6495c506"
    sha256 arm64_sonoma:  "614ac0e1438d0707222baef61aa8f83f6d899a56c92f77aab40e333c464045bd"
    sha256 arm64_ventura: "71b057935b01cf25ac05f2192504653ee8ccaf82e54993841d46c4f95e3b4dd2"
    sha256 sonoma:        "7008a2ea70705c1b10546be6bb645daa59a7263027c5c4c428aa6ccab357e042"
    sha256 ventura:       "804761f93f806a4c44dcbd949fd859849a64ee66c090b3f6065120135615b347"
    sha256 arm64_linux:   "f57cfdf0a178bee76eaf589be5a64b08fc49ebb574927a788f10c849e26107b6"
    sha256 x86_64_linux:  "cdad96712f12c21c250322ef9769a3cae512d316ad901b7bf2d383941ec6ca18"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "abseil"
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
