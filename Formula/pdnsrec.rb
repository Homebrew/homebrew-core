class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.2.tar.bz2"
  sha256 "bdb4190790fe759778d6f0515afbbcc0a28b3e7e1b83c570caaf38419d57820d"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "eaf87ca664ff69f3be92992fe0774042b93187e3630390a7cf3a4047a20357a1"
    sha256 arm64_big_sur:  "664880ce0446e7965715d82d749f85eacb9bf5f4c58c2d4e749377d58e1569fa"
    sha256 monterey:       "404440e127305e654a6c60490e683321ac011f8408629a2a9378bc69460ca115"
    sha256 big_sur:        "3f35ac586a4b248da2184701c40509ad7c8addb36a6322f28e8b67eff986e300"
    sha256 catalina:       "a6ae8a2ac3e2dd19458244e77c1969842c9108c7922b8bb2c5a7b55b9a715ce5"
    sha256 x86_64_linux:   "e6fb7fdc806672b7d3bf096149783d142af0b1b8db05e7a5c8aacd4ade50f51e"
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
