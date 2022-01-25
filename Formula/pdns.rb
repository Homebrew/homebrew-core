class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.0.tar.bz2"
  sha256 "b9effb7968a7badbb91eea431c73346482a67592684d84660edd8b7528cc1325"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a507c2cfe752ccb5363d73f7637e18d811fd1cba879e2901a9f81a53ead3f929"
    sha256 arm64_big_sur:  "e178018025f5f4d2262ada108877b68265217053fdce8e63b8dbf152fc0a8cc2"
    sha256 monterey:       "30386a54ebc8bdbf468f9a3fa3781c5fcc77ae3b22e9823b587f9fca1a8b274e"
    sha256 big_sur:        "037b0b9ace257e57f2de70f62b7b3bb16ae207df930a0f4fb6c82187c7308315"
    sha256 catalina:       "e06ffd3cdfb4fdb642a7ca13d1b98c134891442ca136b862321580b440d4b44f"
    sha256 x86_64_linux:   "906e62ac55d42473516ccbfd9b3fd1f802f2633dea72c221c81c90cdd4b9b587"
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
