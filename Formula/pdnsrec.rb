class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  # TODO: Remove `ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib` at rebuild.
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.2.tar.bz2"
  sha256 "bdb4190790fe759778d6f0515afbbcc0a28b3e7e1b83c570caaf38419d57820d"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "996f9b9531651e71db530424593831d1a3542be24f14f0faf99a954231c72efc"
    sha256 arm64_big_sur:  "ce49a5878b3bc0688b55db78f61944920f08b8e3b0cb69ef0af5e0953a80c250"
    sha256 monterey:       "69b83127e15c10cb0e61b771957e87b6122ba8bf96c4ccb4912331099a0bf070"
    sha256 big_sur:        "e5413d9692d3126b61691d2aa9312f8fd1bc4b07672f60972a38d727b9dbf8d6"
    sha256 catalina:       "72997e0dedff8d1a8849bfdf5edfce30f0580f29e17b7916b4679ed90044c7b5"
    sha256 x86_64_linux:   "31d8350a71157c52885249613fdcea1de08676164d275704c3336fb43b2bc250"
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
