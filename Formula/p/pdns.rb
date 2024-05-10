class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.0.tar.bz2"
  sha256 "fe1d5433c88446ed70d931605c6ec377da99839c4e151b90b71aa211bd6eea92"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a747fb5e8f00c5121ba417788a7967657ba5931818f5583c5988566dd1210d81"
    sha256 arm64_ventura:  "118b0087c1d795e315a9c7772216aa7a127ab2ec42df32264faacab2fcbcfaff"
    sha256 arm64_monterey: "792902ee608dd15d590327b3a376c93f4c723168dfdcc973468319eacd02fe3e"
    sha256 sonoma:         "292ab43cc6d0347dae1d01658b5741be35b01a427259f2e585abea959fcf3d4f"
    sha256 ventura:        "c5f44848979cfec46827e0352c28b15c3d537095b5869215451bdc3e1ec9a7ea"
    sha256 monterey:       "c5fa65482165902e2dfb6d696202883a8898f1ae01c987ae2fa9719c26237bf2"
    sha256 x86_64_linux:   "5a1583a3059b7512b5c8630c72cda1485fedaff69a8db14ab92dc334234ac3ab"
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
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
