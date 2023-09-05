class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.1.tar.bz2"
  sha256 "66dd3ee2654f42b4eb80260f94ecb48e313a81817f58125ce48c14c2d26e309e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "eabf44a3aad399c169867ea822800db7613c79383441c06a3c7d00ac997a9683"
    sha256 arm64_monterey: "36d6e94de5c8778fd7879f59eb89a658ebb4a18485f1636a205d484491d4b1e0"
    sha256 arm64_big_sur:  "c5aaf0f865fba9120950c2d992d9c1306bb99f4e3ab83bb1417c11c5b4684d95"
    sha256 ventura:        "a2d5d0f90de5ba508ba2667c72fbe84a57216668ef1ed508446a54133fa1cec4"
    sha256 monterey:       "133ff6c7c2b7d45ba37b4c2672c921a18d948b66732218b8fd0a97e16f4bb29a"
    sha256 big_sur:        "9fbaea03495f8995751375448235d47e784881a0439fb90515c254a7aa52d62b"
    sha256 x86_64_linux:   "d5b3f0f15479db7ff7a742b0509ea99d833a96875d6ead5b123eee3808993adf"
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
