class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.2.tar.bz2"
  sha256 "f443848944bb11bbb4850221613b3a01ffb57febf2671da6caa57362ee0b19b8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5f11785a7f2ee10469a79ce44fc7c58debd796445de4710ade9169e7f0a6396d"
    sha256 arm64_big_sur:  "7488177bc07804ef18d17979aa9693c938d70b91c4b2f9c6fcdf453bb67c578b"
    sha256 monterey:       "5b8647690138a9cbd97f5dd525a407d115d77ad4fd0e4fb70e10a947df0d187e"
    sha256 big_sur:        "67ec5b6f05c1d9f73a43ecde2f6fe66de077bf5ca80163f5f0c616fe878a6b39"
    sha256 catalina:       "01424ecf828fb8645eec581e9bdcfdab89662d8bde2f9d8c7c9825890b3dbaf2"
    sha256 x86_64_linux:   "f139bc7ba7de91a697ef355d3b1eb201fbb02219e809754d3b4266978a6372ae"
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
