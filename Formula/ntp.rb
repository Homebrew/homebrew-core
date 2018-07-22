class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p11.tar.gz"
  version "4.2.8p11"
  sha256 "f14a39f753688252d683ff907035ffff106ba8d3db21309b742e09b5c3cd278e"

  bottle do
    sha256 "7f31f03699629db42395a843e01800a3733b5615aab17fee1a631ae1a791042c" => :high_sierra
    sha256 "fa9f1682235a5b26539f86fc1f96deab602898f90c9014a81e4409e06606d842" => :sierra
    sha256 "9f49c8fb9b0f4ac8b5cf730d45d13656e4e80fbd030e6f5a92d26b1d5fe6b9bb" => :el_capitan
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
