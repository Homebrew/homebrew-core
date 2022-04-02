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
    sha256 arm64_monterey: "8da24028e6f10ae2dab46dee8c6fc20801cb9709e99b7460e614969505ab7f88"
    sha256 arm64_big_sur:  "8e1ca91b6b340277d3cd7cf83adcda83b8d2368bdbb574ac07a8832d5291a279"
    sha256 monterey:       "4ad8cfacfb404f9faded18e4250b55e6b9bfe478c8b9d7964f312d251c35af8f"
    sha256 big_sur:        "b915d575810b63f9bb2e7293c2bd38374e462e46fd32869a81c4f394fed34b84"
    sha256 catalina:       "8235e7128700254260d7961cc612c1f7a7d1aac565415deb6d5e1b2259def053"
    sha256 x86_64_linux:   "fccccc578dbda229e7d563414bac0eb14726e5b6f1151b43e250c7e39eec6395"
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
