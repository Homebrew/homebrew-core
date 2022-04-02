class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.6.1.tar.bz2"
  sha256 "7b8500908b84a87ea8a021cbff3f6c1f9ff95f0199e7c972b15b93dfb1561ceb"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "93e6af47d213003bca88fef675b0a55bfd23776c1d08fe42abb3853debbba35b"
    sha256 arm64_big_sur:  "4b0eedf1b6832587c77117cd2a26c0c569df5c8f9dca0305401086a8ee757307"
    sha256 monterey:       "691ae6ba333574a17c2e59da0b46064e9cf8fe93c5f045fabc5f136953ad5cf8"
    sha256 big_sur:        "35e07bf7ce35984810ef4ffc578b55fa1a2ad5a1563cf9c21e840dcb7161c403"
    sha256 catalina:       "f5b996bd85d957ac8a0975c1c6bf33e7eeeea8f073d12f369670aee31dd7c7dd"
    sha256 x86_64_linux:   "e78c1fc783fecc0502dad1ca091825bbbcd8578217dd4cba36a1d96ca7232b33"
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
