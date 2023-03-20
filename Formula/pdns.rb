class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.7.3.tar.bz2"
  sha256 "8bad351b2e09426f6d4fb0346881a5155fe555497c3d85071e531e7c7afe3e76"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4aa5b0228da482c638f6d081671c0abb86be08e8e82563f424d2d0c522eb4f75"
    sha256 arm64_monterey: "c18d0332865dec9fc61589ed11f2ae486eb71d3dd6554b2426c49ff6e1bd71ab"
    sha256 arm64_big_sur:  "a0abd610b3b2e64f6b03600d4246e27b43cc94420328503b457d359ddb0d466e"
    sha256 ventura:        "5a9effa37cb64be78533c3a1da8102b6f9327a688fd2ea50b71148d972bbc6b3"
    sha256 monterey:       "3064b44f8b7db382841609e68f35facfd79b1a192678206245c346491a915fcd"
    sha256 big_sur:        "acc327271d434c27713f1cf1378aa4a011a044cd5edebf1156e59f504114421f"
    sha256 x86_64_linux:   "23646d48d5d3910738904dce0da32e5775deaae8e8ba553a7c2d722e0bf4f81e"
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
