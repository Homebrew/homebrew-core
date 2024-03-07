class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.3.tar.bz2"
  sha256 "01d170a2850eb2aca501d6838a3444136589980d5cb2c2b53392b76459e38c07"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "505da5cbddb88b4b1042f5424404745b90831fc884bd010494860e5cfa0b7273"
    sha256 arm64_ventura:  "07b7dcbefb03937ee1c463d9089af52f629f401b8449061841fea31155e08479"
    sha256 arm64_monterey: "0687101f71011c37a3b9e189827a19d8e67165f21f00a3457b66282f18fefaec"
    sha256 sonoma:         "8688cc613a6afac94d4cc37efb14c4263239b1303a058803e2edbb8decf8b487"
    sha256 ventura:        "014279aab7cef287662c458d0b406c27beb83cf77c2e114b25b6307549ba8fad"
    sha256 monterey:       "0bdf36b0d1b95f01f90287057e1ad356f43ee26717e4e04ab3795226ed28c26b"
    sha256 x86_64_linux:   "bdcbe70f21885d039b0f3ed5f7abd790a43a8458d52c992b54f1db392fc6862e"
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
