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
    sha256 arm64_ventura:  "59cfc811b651746d61cabcbab95410854a24051e007aebd38db80e252dc75082"
    sha256 arm64_monterey: "b704cbf21bda048466af2884b66d570a535b5444d6fee82633cc8b2f3780937c"
    sha256 arm64_big_sur:  "7d93a30819e08d6ddccdcd220417a51e730fea410c16751ec147c10ed04c799a"
    sha256 monterey:       "ed8a45caf1562e78488007a8a6141cb3eb10412ff747623d03371b130628f0ac"
    sha256 big_sur:        "1226a53729426ba7f1daab320c692071f39347f81cd9308a51494fbd9b34a1c6"
    sha256 catalina:       "f954d25d644a0329f3c9fd0c644797470d773e19d5570bd312ef54762b0d0996"
    sha256 x86_64_linux:   "7e5889323ae33cea3aafb4ab1f828d14dc7a6be8415f5220bb9c5a91f6cb1938"
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
