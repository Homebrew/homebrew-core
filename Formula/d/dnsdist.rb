class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.3.tar.xz"
  sha256 "a229250b819c40d55173afa7202ef1ef2a6b728f85c7506897a1f1ca6ab57149"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "02d3190231960bb459cac4e6ffa9c56a58183f4738c6d0af9fac96b32c31398a"
    sha256 arm64_sequoia: "3f3e09fcc8094f2bfe0684a44e0b47825ac3932d6ea3a637671202f85a47ad1f"
    sha256 arm64_sonoma:  "8bf8482514d6c6c921127be77e58bb2d02025eeee2691d9949246a0fa57298a3"
    sha256 sonoma:        "83a61615d1583d6c108680b8dae0e47fe30a71a4cc5c937f13fe22d87f22ab0d"
    sha256 arm64_linux:   "b235618c08aed30dbfcbda5bdcffda7c9a7d5ec7e71a4f5364826d20cd20c1ae"
    sha256 x86_64_linux:  "2b375de6178b9acb4f9f93d1b189138c9219ca3c7436c2c973191dfe8fa4eea2"
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

  pypi_packages package_name:   "",
                extra_packages: "pyyaml"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    # Fix to error: use of undeclared identifier 'vinfolog'
    inreplace "dnsdist-protobuf.cc", '#include "dnsdist-protobuf.hh"', "\\0\n#include \"dolog.hh\""

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
