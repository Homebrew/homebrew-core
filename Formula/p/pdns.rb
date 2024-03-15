class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.0.tar.bz2"
  sha256 "fe1d5433c88446ed70d931605c6ec377da99839c4e151b90b71aa211bd6eea92"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f7b4b1fa2158a25f2d5662e33c77b8e34e4d11a4d4c9e434c6a470ad08e3c6dc"
    sha256 arm64_ventura:  "27262bbe2caa26c9d25cc355c1e40e60f54b1fd5f3b0a6a3ca79ee4524fa64c7"
    sha256 arm64_monterey: "ea3241b4e0ff16b7fb342941f8b0e594b0581621abd02285dc762f1c20e25a59"
    sha256 sonoma:         "9a75120aca217d4aca65bd6739f2ab495fca172f898e6d1602be1f9d7838e55e"
    sha256 ventura:        "94e4cd95fd076ed7d6fee0bbda9c69813b63ef26dc15165dfc410764a3b27f40"
    sha256 monterey:       "a71a94b3ebf1b087f464c277904e70675181e3f5a1059fcc92b2c9b1a19156e1"
    sha256 x86_64_linux:   "7d94d37620bb9245e30b6cb33f70d68758a51f4fc37eafcc7a16e6ee4af7bcb2"
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
