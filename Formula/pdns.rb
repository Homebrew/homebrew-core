class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.1.tar.bz2"
  sha256 "7912b14887d62845185f7ce4b47db580eaa7b8b897dcb1c9555dfe0fac5efae3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f672a8c912f63fdb949567d7bfa9785f9188932f782b6a2febee0e43d153ed40"
    sha256 arm64_big_sur:  "e973031a1d6efea0945c3bde82f36fd173cef097f118fa9df73d725aae4c6273"
    sha256 monterey:       "b18b8cb99d96022fcd9334f214a7f493ee7eb2eea598b21c4d4fb94f80f7e312"
    sha256 big_sur:        "c14736c48b3e96deaa3ebe3c171002278fca922bbb987414bee7362949b0461b"
    sha256 catalina:       "905287085825e3214d0da703118ab87c972e6ef937813ba185d79b3e269fb2da"
    sha256 x86_64_linux:   "671792c1736b764803964b61f84db794ad0991b9e22236f8ac68594db48eb91d"
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
