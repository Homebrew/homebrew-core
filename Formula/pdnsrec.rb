class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.6.2.tar.bz2"
  sha256 "da649850739fdd7baf2df645acc97752ccd390973b56b8e25171ea7b0d25ad20"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "de6a762998c22ad46e0063fe9b8372c9fc3cc19850d9bc8d86dcae5210c90a4b"
    sha256 arm64_big_sur:  "801b99e504edeb30697cf91b81cf8f9859620df0cae119650ddbed62428dc9f6"
    sha256 monterey:       "8b24383a480c4f1afdd3ad0972c24cc162e5edbf66d25d192bbe93a65eef3434"
    sha256 big_sur:        "824dedc593020e36d597de52c23515c3207766c7abb7da55eed96ade94c02595"
    sha256 catalina:       "6b296f66fc554ae086337e200687a47ea5ee07e0fadbb6329540a0097509adf2"
    sha256 x86_64_linux:   "bc1342ea267b113fd8e3825e10441c4fc2d55ff85ac37368d781c29d8922d406"
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
