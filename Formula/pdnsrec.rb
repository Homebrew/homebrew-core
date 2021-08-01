class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.5.5.tar.bz2"
  sha256 "a836a39b99fcc21873e4ba3a60aa9915a33fac7b44922696e9a257f551fe05fb"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "da945ba43769742cd9e0263e6c12e81a6a1e2efbd039ca696257f77284f2dc8b"
    sha256 big_sur:       "f49c224c33ed279bcb5b932401b69448dcbb8d6738413bddf67e6380685b3844"
    sha256 catalina:      "f788ecc3c854cae9a7b5ea0f4a72c7a6631d60ae8f7d1d87c3fd24ca84a89f6b"
    sha256 mojave:        "fe84e72a0968bbcad84bf3cfb8d46c1676801c8808b9084b9bc580e22d727c4d"
    sha256 x86_64_linux:  "fdae24f7ccc5dcb221f5a6d544e508b9de96f9dcf388f9b81335dcfa6790ab65"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
