class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.5.tar.xz"
  sha256 "23c67dbac21e5564df95b67899eacfeec7d7c194118aabf98ce0e763ccd5c7ae"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0ae6fa51cc15a5683fa699d4d2c4a8888368cc5bb5ea171cc3c6263db559791f"
    sha256 arm64_sequoia: "1ff779e73f5310128cfa2aa6804fd272727af211607a0701ef806aedc6563737"
    sha256 arm64_sonoma:  "92996b4b09648c5693c201e86b80460a40e06bb30e88194585e5105d7a1b1662"
    sha256 sonoma:        "46532e2ea4f61385f5147ed43a3aa3c232c731a4ccea3724dbd64cdbdd335968"
    sha256 arm64_linux:   "da307f33296e8735ef68fade02491afe43b916e0fa8015b377b5087f8c873ab6"
    sha256 x86_64_linux:  "8fc5c80c998414498ad1190e66cc9c91bbdc8a16de615fb6793c1e00dc9aa691"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@4"
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
