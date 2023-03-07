class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.3.tar.bz2"
  sha256 "37b91a5458c54411f4e38e2d1263ecf41e751e43c5fd66e813100d9978f02505"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "94aabdea2dcc4d4c291417607004b9fe7d921b3c36ac61308d3b5f397ba8b6bb"
    sha256 arm64_monterey: "c2a9643b0b1e8dc072204d4bd5d6828fb5aae044ef8cf3ab087e37aba09c7980"
    sha256 arm64_big_sur:  "777e609ca4336474c6ab57a34e585ba60e6d6f4af67709b58bb7d001b4468002"
    sha256 ventura:        "802ff0f328fdb46b8cf99a7cd8a3f8d45957ef2e53661f3b8b2db24a4f45a93c"
    sha256 monterey:       "04947a688af481550b6ec8753c7b643f0d90149675fd5918d948106d496c0bfe"
    sha256 big_sur:        "c6c69eba0a1b75dc39b0d23d2a462bd3da7ec87143007627ea76e7c26853d917"
    sha256 x86_64_linux:   "307e3d67b38e592caaa964272146b36152b8d586d900b1bcc9fa3ac3d836334b"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

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
