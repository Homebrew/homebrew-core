class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.1.tar.bz2"
  sha256 "d2f94573a6f0e63a1034ca2b301c27ebf2e1300a655ba669cc502d5ea8d6ec68"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1b493ba9a3f1f7cc1bb9a2fedb646671ca5dc00e2155b27b62a41194fa2c1e7e"
    sha256 arm64_big_sur:  "ac8d88349dfc62904189992221cb06c37c72ceb34ff63d4c6e781ba663f41688"
    sha256 monterey:       "f9c1420a1409ddaee0ae062b3ce46cb970ae600246309cc960ec556d741faf77"
    sha256 big_sur:        "10e1715d27edbf71a392eb5b6d0e1580c2839f9a429091e623f94f5c10ece361"
    sha256 catalina:       "744a16dca515784cc29d9360a3f89791ebe90c22c8a73bd7492459f63abfef16"
    sha256 x86_64_linux:   "987a053c68d769afa639d3feb64b853e0de8fa7337e18200d4add9a90a0be97b"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    # This shouldn't be needed for `:test`, but there's a bug in `brew`:
    # CompilerSelectionError: pdnsrec cannot be built with any available compilers.
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
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
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
