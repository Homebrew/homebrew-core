class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.7.0.tar.bz2"
  sha256 "b57b75b780ace64e232c6757f17a8fa617016d0128256c66f22da5f4b5e839e7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0c560ade91622ef41def52caab6db0762e538de43dfc76ec1af4882ce5c4a189"
    sha256 arm64_big_sur:  "16aea452ce5a59bbf9e691abbd7a8016375ab7b9f60b3282bbd58cebe7d30718"
    sha256 monterey:       "57bd42fd4263b2eda1f89d09d1a1fe150268f7929d6278f5d9509560fbbe25a2"
    sha256 big_sur:        "968323b83ece2caf4ad72025a11251dab1e41efc3b159c75c3f03ac3f2a9ca9c"
    sha256 catalina:       "139d0ef1d63f678ccc1163d404450f72e98f36842876981bfa228dac08f39573"
    sha256 x86_64_linux:   "d7cadd9a863125d89742f43f3aedbb7fd2d690e4d26959478f77c4b990eeeb1f"
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

  fails_with gcc: "5" # for C++17

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
