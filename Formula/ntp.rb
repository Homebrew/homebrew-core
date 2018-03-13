class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p11.tar.gz"
  version "4.2.8p11"
  sha256 "f14a39f753688252d683ff907035ffff106ba8d3db21309b742e09b5c3cd278e"

  bottle do
    sha256 "5bda263067c4c0fe391c49734680e3f682f8c64672cf0628344db78df6cfa371" => :sierra
    sha256 "eca0868f7a11c02bd5007602a534257fbdaa06aca5348e32cd06264728569e14" => :el_capitan
    sha256 "766d2595c081694b7da0e5cfa6818e60483329f5ec7e2f1bf179f180735bbdc2" => :yosemite
  end

  option "with-net-snmp", "Build ntpsnmpd, the SNMP MIB agent for ntpd"

  depends_on "openssl"
  depends_on "net-snmp" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-openssl-libdir=#{Formula["openssl"].lib}",
      "--with-openssl-incdir=#{Formula["openssl"].include}",
    ]
    if build.with?("net-snmp")
      args << "--with-net-snmp-config"
    else
      args << "--with-net-snmp-config=no"
    end

    system "./configure", *args
    system "make", "install", "LDADD_LIBNTP=-lresolv -undefined dynamic_lookup"
  end

  test do
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
