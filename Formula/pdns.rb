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
    sha256 arm64_monterey: "334db8dc8d54c6fbdcc468b38c65edaa10d4739625c92366704b729dc397fc38"
    sha256 arm64_big_sur:  "db64572ebb4e56b58b66eed8de689e706e09b1eb52c9a75e0769fb52d45560a7"
    sha256 monterey:       "156638102833357e96c24bd695cd652f650d19425f314123d7d3fc4317413310"
    sha256 big_sur:        "1e6dcd422466787c2d294e3eccb0c007dc7c19c57fca0c26c14f373d7fd0c66b"
    sha256 catalina:       "17470dcf7e06e20d8f0ae61ed32816b27e5e9e44d949aac472d523a0ceb0d6af"
    sha256 x86_64_linux:   "fde20ea04ff5af88a89af9fb3d543d9d6dd77e0884b11c9bee55048e9b386a3c"
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
