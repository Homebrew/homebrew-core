class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.0.tar.bz2"
  sha256 "e4872a1b11a35fc363f354d69ccb4ec88047bfc7d9308087497dc2ad3af3498c"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "57530d84e93985acfb861e54e049a632f384fb3ed03294934d46e8d694b99b99"
    sha256 arm64_big_sur:  "a7987bdd9644287bca00e88049aebaa891b3ccc9b11e47e9917c3a3fd5f30d96"
    sha256 monterey:       "98352cb2db36fcd5de353a1c177658f6c51b87dbe6b77455b1f657987c19f1c4"
    sha256 big_sur:        "1746024cfa12b0b5786d649d96afa87b0113df1fa9007971ace2561866cd49d4"
    sha256 catalina:       "58820ddd18e91bb3b844ff2103b115978be3b1df5b26c7c3a61017df548fc82b"
    sha256 x86_64_linux:   "21162c46a26357c503a07a18bbca90e4f660d7ccf192eea0883de0b83ca949f3"
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
