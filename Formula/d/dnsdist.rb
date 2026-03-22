class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.2.tar.xz"
  sha256 "3374eba65a5ca3cfb9fc59791c47e5035149fe521ccbbced5f834a17f45641bf"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fbee023f28414231a54fe396bcc08d5bb4e5ffa2a06a6272d781fb148f43567d"
    sha256 arm64_sequoia: "7222dea3cfe65f938d4832ee1f5eb6c296f1e966045db4b1487239c78c5d3339"
    sha256 arm64_sonoma:  "ce89109032eafc18beb5aecbdf7c2813d70f3631ac46a83db209d5fad764faa8"
    sha256 sonoma:        "14b4c030de8c8aaac5576edb7dd283fa56072fbe2e0c5f13312ac3c7ae9a6713"
    sha256 arm64_linux:   "01adc30a863af92cffac4ada15498e4bae8fd6e05da8c2700482be4081cf197a"
    sha256 x86_64_linux:  "cfad2f9f9f79aa4f09c4c5cb93bb76f00218183b540e52d8b0feab38a30c5d42"
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
