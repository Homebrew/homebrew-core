class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.5.7.tar.bz2"
  sha256 "ad4db2d4af4630757f786f3719225c2e37481257d676803a54194c7679d07bab"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "95844dcee70bd2c3d66e4369549e9ed9704160398c44cceace9b3b129bf34274"
    sha256 arm64_big_sur:  "41ccbf341f375958dc5ce1350364640963b83157e6861474c2e050bab7d16b96"
    sha256 monterey:       "121d09723c72ebfdf7a0c278b216a13a4cf03d4f28756acc80863732f3a2ed85"
    sha256 big_sur:        "c49042c1dfd2f893f8e6beb7f87bf75a647109c91b795756302b5e0d11141c84"
    sha256 catalina:       "95bcc5e9abcc15975525825e675aa9647b784f0cc3d6cf7c2211da9adb2ac729"
    sha256 x86_64_linux:   "0b71fd8f38a5a24c1ca2a76ea5ecfc9faab3b56b5fa02d544f9d9d4acd24e806"
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
