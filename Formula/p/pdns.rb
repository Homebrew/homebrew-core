class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.4.tar.bz2"
  sha256 "7f40c8cbc4650d06fe49abba79902ebabb384363dabbd5cef271964a07c3645c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ae227d495c2a729b2b6442f8963ee9b4715609c0a5b9011389f423c3442b5a32"
    sha256 arm64_ventura:  "f9bfb758d32974b5d6a0911ac4e498d1fb899597c7ce529bf0561ecff4e7cc9e"
    sha256 arm64_monterey: "e540ac2d196e97ecf4790503fc0789c3a9dce5b3b37e55925865ba83b8b55a79"
    sha256 sonoma:         "11acc8e928a9cd2fb3e798dabeddc1e01cd0c2986863b74d69952e2885d84c4c"
    sha256 ventura:        "11e2f36404dfbf67fd3c9d798d01c7c71759980a859d63626c33c0602610215f"
    sha256 monterey:       "cec1b8c273d52754c99638f5c1702a1db82a464bc0741cf794138fbbc53af03e"
    sha256 x86_64_linux:   "94ca83ae0e1d6411289d0f4b277fbd400f4b87928890c06b01a50bb1a2737816"
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
