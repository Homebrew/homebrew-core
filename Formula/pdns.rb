class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.0.tar.bz2"
  sha256 "61a96bbaf8b0ca49a9225a2254b9443c4ff8e050d337437d85af4de889e10127"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ddacfdc670403d10338e3a7816abd316ffb8c9dfabd8d698e8bfb79a383f1c9b"
    sha256 arm64_monterey: "f16cdc982cf9051e4acb359084a968ec3fa0ed8427758f8b3e09445347977266"
    sha256 arm64_big_sur:  "17f9622ed9aeaea30f075e9c81516970f3a9e3a937b681a25e27fd29348a0054"
    sha256 ventura:        "9cb505c2254a030c2b3f0f2d7512f2c3d7c9859d935e9024f82767610bb9601b"
    sha256 monterey:       "714e7e8ba7f6cea7d73be54e1127e59f0204e8fd803dc421dd4d8783e791c83a"
    sha256 big_sur:        "d9902f1335aed750d04bcccf0baa8a81a871dd524753f502799d33b46beb2c7a"
    sha256 x86_64_linux:   "cf721236650e51867b5e8c0217119284384cfbf24fe502d995d20285a56bb546"
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
