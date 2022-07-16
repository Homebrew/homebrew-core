class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.3.tar.bz2"
  sha256 "acd06b89ca01d1adf61b906604614f0e1d77a1e94eeecade8ff5d53a16db7389"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "29981f239948541a8818101c1cab5d3434e1ba54d8de03420b0399839b145017"
    sha256 arm64_big_sur:  "e5c8280b9ed7b3c967bd751a7265780274a14f247cd6e7c5c3cefc2437601fc5"
    sha256 monterey:       "a0ac1388be58ded0d960ed1771febfe10526ce6b38fd2e1093550dc5a8b0650c"
    sha256 big_sur:        "a4ae15151fba539cd5d6f43a88156a7d5acae9117f140aabee1f15c668dd561f"
    sha256 catalina:       "9ef888683bf9af60f60787f0dc13c65cba650c0747274356a9819472c32a2e7e"
    sha256 x86_64_linux:   "784b156618c7a94f6176d636bdb1a0f6ea3a61f5afddc2191cb4be06748e5753"
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
