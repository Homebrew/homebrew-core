class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.5.6.tar.bz2"
  sha256 "bb89cdd3810467ed848d13cac99f6f3456bf0ddcce5f47b9d38673629ee79200"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "17d294f7b29f9206dbe09d04d2b2fd856295ed2e26caebeb226dbb926cb62225"
    sha256 big_sur:       "84db4d875f98e655ef4f2b33ee923ad77a3b5077e333e1dad1e5d601035c7256"
    sha256 catalina:      "f5816c04766329c60b7643a07dc9652ee710001806d4fbf80ba4a0915be0639f"
    sha256 mojave:        "0c93c4cc2b542487d278db7797ffe6519292125358215bed274f2cf4ccb9a82c"
    sha256 x86_64_linux:  "810d3b7b5d8b13ee6935e4a72285a686d89ff239e0e77d6af078a32020190540"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"

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
