class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.6.0.tar.bz2"
  sha256 "df06559398aebc594d2e1e27d177f981bdbbc17f968d6306a52aa7d1119fbcf2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3ae2f4903ffdbebd9cba7388063efb8dd9b5d6c118b6cdadd122e1bede2bc3ae"
    sha256 arm64_big_sur:  "4009f6eeddca43e1155e4fbf7a4f0effbeea6a9f9c4251a31bdda6c2e446ffd5"
    sha256 monterey:       "930825ee96dbfc8823c825047450fd9e65199b677477a8f351944d728568a6d7"
    sha256 big_sur:        "228c1e7ff4ef21168db86ee6799812fbe1a285d3d9ed43a9e03d62eec7f2249f"
    sha256 catalina:       "cbb6267bbcf139a367d14e985570b5390e523367e0039c9b25cef3aa5bcb9955"
    sha256 x86_64_linux:   "f9bbd9c159c9f62d90bfd198f22c53fae36bb947196033834ee50687d44c8479"
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
