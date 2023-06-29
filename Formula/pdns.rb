class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.0.tar.bz2"
  sha256 "61a96bbaf8b0ca49a9225a2254b9443c4ff8e050d337437d85af4de889e10127"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f6da183223c39efaa69bcb18245d398539db09461d137f5411665359db510ff9"
    sha256 arm64_monterey: "7f3e54863b7c474660731fcdcd3a551d3225656a883a086d08043613d2abeb3e"
    sha256 arm64_big_sur:  "beefd178e9ec5fe86bebc77c05bcbaf82b2029c12438f49374465a7d7aa9a571"
    sha256 ventura:        "9dcbcf33e111f1e735329865a7d76484523b81ff03c25d117ca2fda0b5d7d197"
    sha256 monterey:       "a8df2aee3006d06a05fcfea3738341f10067d8b0a428d555a822ce730ae33f34"
    sha256 big_sur:        "00f76eed66bfa3c1079015207a3bcd89b18502ca193a3fc48b7701adf27a466d"
    sha256 x86_64_linux:   "41ab5d44e7bddc480fc02c8e15f215546457ac1f2869e76038ab0fbec907ae28"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
