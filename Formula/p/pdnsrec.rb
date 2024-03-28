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
    sha256 arm64_sonoma:   "36834fe910fd8c845e4819cd35fd3b04f6359b5165264afc20abedf8387d4081"
    sha256 arm64_ventura:  "48f83494d7eebc73af931c095dab17227610d3c5e6e23f079860429648302346"
    sha256 arm64_monterey: "103c2f1a7afe19ad90f41e72a6b0e8550754c66a72fa3404f5bd33df4e77c6a2"
    sha256 sonoma:         "475624d8e181eb910db8387923d82724acde79704a51906520c673f065ead0e6"
    sha256 ventura:        "b38fb2035f8a7d872ce6d0f3337941841f72c6c760c76c1081fa3f6ab671c984"
    sha256 monterey:       "2eb50158597c8108bb84355b31f6e11dd590685f07507d8eca1edc140d10896b"
    sha256 x86_64_linux:   "d5bbfc45dea4c07a62517043a6386f129f72a1906b3e67e16913e0772c343079"
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
