class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.2.tar.bz2"
  sha256 "a90e8b61fdc181b596144c35920118ca71c3b95f46658cce7e8222750de45ca9"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "81ed4405bf26381ef8c0518e5b9591761b2ec4829fad5f37aac7e1f1c3669ac0"
    sha256 arm64_ventura:  "6b76d8b50c9c5331c13452cd110ee6396f4b0463b2e392484b43bbea6cf8a99b"
    sha256 arm64_monterey: "c59579b1a07cc235e18f0b40d7dc1e530578ec72b98384b304710bac5416a0f3"
    sha256 sonoma:         "cc6a4f018d4b912cd5efc215824898a5ca378c3c2b364f359c6d64d15bf840c2"
    sha256 ventura:        "ee9c8e6a1f52aa9055002dbb67d6d6adc476648e4911dcfabbdb3ca3e5e1d041"
    sha256 monterey:       "b357e30e8ab9ecd5896ff0f3e73aa088e6f529fb15304f7a75f975fb8a9c47ac"
    sha256 x86_64_linux:   "52f3b279ec4cc28e41735b606d3792dca5dc5a7dd80be27ec1df84860a094987"
  end

  depends_on "pkg-config" => :build
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
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

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
