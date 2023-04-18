class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.7.4.tar.bz2"
  sha256 "7469dd81fb7df11197f49638fa49ceff9f973225fc8f9c7160b0bfc00a2e7471"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e4124cb39ff97448ce67b7076b17b2b0e79c3e8ce36788f560a1dc8b6117883a"
    sha256 arm64_monterey: "2a50f423801509f282346ae64e95d6174adf7cdb1ac5fcde0610a0cfc5bc09d4"
    sha256 arm64_big_sur:  "d5371d7a25c2939af779722c74746e081395a324a92f6c48ee4d5440eb87edf3"
    sha256 ventura:        "69044c2a3ce20c58f19bdbff5d11a54a814771066030b67fa95db2cd8b246dbb"
    sha256 monterey:       "91e282b31ce5ce97bc7ca0ae223cb7f963269911f1d6aafe72273efb68b0d21c"
    sha256 big_sur:        "7d02e6ffc9924b96ed7ce9a4bff45e2e4d21958a8cedc0f085a3cca6ccff98db"
    sha256 x86_64_linux:   "5fd79c35623eb608c840054d15a81531fe5019ed261cbb3d0115f0e9814aff7b"
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
