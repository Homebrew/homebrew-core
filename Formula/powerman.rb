class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://code.google.com/p/powerman/"
  url "https://github.com/chaos/powerman/releases/download/2.3.24/powerman-2.3.24.tar.gz"
  sha256 "85d5d0e0aef05a1637a8efe58f436f1548d2411c98c90c1616d22ee79c19d275"

  bottle do
    revision 1
    sha256 "f0c2779ebd34bf10ead39d82ffd90ca58ae17780e3bcca769778840b87889c4e" => :el_capitan
    sha256 "d66a3faf7b2e5e07a56a3160158a3d9dc8314a2ca0acd09ba7b8ecebd42fc9e9" => :yosemite
    sha256 "ad709cbaf0eb057c18ca98a8c9215132785b3d9a751df89600c38059b7b12265" => :mavericks
    sha256 "c801c9d90323a6817a144dd9bf24ea095642eff51cae2500451507a367701546" => :mountain_lion
  end

  head do
    url "https://github.com/chaos/powerman.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-curl", "Omits httppower"
  option "with-net-snmp", "Builds snmppower"

  depends_on "curl" => :recommended
  depends_on "net-snmp" => :optional
  depends_on "genders" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << (build.with?("curl") ? "--with-httppower" : "--without-httppower")
    args << (build.with?("net-snmp") ? "--with-snmppower" : "--without-snmppower")
    args << (build.with?("genders") ? "--with-genders" : "--without-genders")
    args << "--with-ncurses"
    args << "--without-tcp-wrappers"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
