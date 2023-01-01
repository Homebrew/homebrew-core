class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.0.tar.bz2"
  sha256 "ccb9017a1a788e95e948e7b240ef8db53ae8a507b915f260188ef343f7f68bdc"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fc109a97f8fa82026b6c2b3faaa0134c179e48c7b779e15b09354fdc1b8a24b9"
    sha256 arm64_monterey: "efc5a8a3f708d7e4cb16635167d3015286b4aa48a5ec2a10d1a3a656fc901978"
    sha256 arm64_big_sur:  "2275505ef435664204ff37269efa3edbd6bbc0c5c226fef7b32bf9f51f9c9978"
    sha256 ventura:        "d8c681ffea4f1dbc882ace3b23a98e55c0e8ebb7bfd7c3a449c1fd8f7fe18a47"
    sha256 monterey:       "df034a27edf1a62891a149697eed308dcac50f6a1e1b86ef1564cb4adbfdb0ce"
    sha256 big_sur:        "e87818b56087d40d0c30e49e0081ec0b351fc49863d1a73d00e66fb65f534074"
    sha256 x86_64_linux:   "6f09772aef97626a83e9e94b6a8afe89d9f4826451b5f01455eeaf13edec5b31"
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
