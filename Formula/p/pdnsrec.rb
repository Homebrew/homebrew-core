class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.0.tar.xz"
  sha256 "6b9f85b6df17c339cbff448d9824bee6da6a5cf884abd99835d1dafdccdda0e6"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "208a4cc406f6f7190d4b86c443296638625dd770b4ead37eb6153ca0dad8d390"
    sha256 arm64_sequoia: "6af01a0b02114906fa491385259e9c0500b2e8ea26fcb0391a0249f6628f4115"
    sha256 arm64_sonoma:  "f46a8cb127071ff5115a18b7b60a9b351a55b0a827a54523ef819a8843d78326"
    sha256 arm64_ventura: "16c1f711c5c575ed8ba69d01b9dd1d6e46fccc4291ac352d515d0e46253a9b29"
    sha256 sonoma:        "fec55e5d001e2fb771789a7eb7b7b881d2dd992edd8d6c46b49f25a5bb0ab56d"
    sha256 ventura:       "109ccc1f50960db7619a810c0f0fa82865496cbf7dce0cdf5371656777a11de3"
    sha256 arm64_linux:   "4bf7b1e6155c148ccc40464fab0478bb3867d4dba0436e780f5bf23a21aec583"
    sha256 x86_64_linux:  "4191d1f1d33a3bb5de04198aa318bf8dd972505c4a95610248ea3e39ce354c9e"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
