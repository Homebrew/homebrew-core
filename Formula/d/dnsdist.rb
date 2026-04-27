class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.5.tar.xz"
  sha256 "23c67dbac21e5564df95b67899eacfeec7d7c194118aabf98ce0e763ccd5c7ae"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "658199bd1694941ffd68ac467a12b3a637bb8600a9164efdc9e28380a272321f"
    sha256 arm64_sequoia: "6e31593ca20a089a2e45f6a228f85f2ef8037d9e622787857c5299717cbbd376"
    sha256 arm64_sonoma:  "2685118e3eff836466637135255411e9192cd88528444363dbb800d7690e2539"
    sha256 sonoma:        "f1e1eefd356cfa14caf04622e224422d4015140409b41e86616b62f1ff36303d"
    sha256 arm64_linux:   "f74672e1037512a40db9f2f81724c6fbe03b6484547c1a5a233c99230302b55e"
    sha256 x86_64_linux:  "3647ac9f2634b897ed5d74fb19b4e05a52594cf2880cb886e9a0b3930d59f283"
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
