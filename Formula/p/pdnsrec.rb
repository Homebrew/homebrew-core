class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.2.tar.bz2"
  sha256 "f9c95274231ee3c5c94197f6d05011d55abf06b2937535ba8e78e24ea4fbbd6e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f1c32a790a3d511170a0d43ca6a633560ae5fc4b4a8f4af7e71da0df25a85b7c"
    sha256 arm64_sonoma:  "deeffd24ff65163be3517d0aefd874e7188e38fd32676350cab0bf63f0fda980"
    sha256 arm64_ventura: "30ccac5a2d9a95a3fdea53f665ae9c1e22112d1fd4414f3dc831764e729ac1c4"
    sha256 sonoma:        "cdafb6f30983bd1ac6290f2eb38a8b850e2219e47b9ebf7b51eb8656e49c23b0"
    sha256 ventura:       "a6d7f49b060d760b96a7de7bd3742a80b6fb66c0a04705e97191657611c58b62"
    sha256 arm64_linux:   "8b8092a66706010bbfe1b6f20cdfe56135bdf8d8fd7e2fdab253a5a7baf62943"
    sha256 x86_64_linux:  "337e469971505d70d1aebd084b7ff273f69397d0c4efc57f2850d0f499cba161"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  def install
    ENV.cxx11
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
