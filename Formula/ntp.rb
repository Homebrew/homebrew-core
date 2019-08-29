class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p13.tar.gz"
  version "4.2.8p13"
  sha256 "288772cecfcd9a53694ffab108d1825a31ba77f3a8466b0401baeca3bc232a38"
  revision 1

  bottle do
    cellar :any
    sha256 "7f30a4c684195c6540cbc43ade3f0a96724853289cc39106d5bd86379a3d1f11" => :mojave
    sha256 "c3f0905c8580acc1b6a8db811733ad6f87e49118c702b591591fa30555fcaa4c" => :high_sierra
    sha256 "48c96f99d19135f055b15066a49a44a1e1560c1da0aa1cfaa8c81df782d86d77" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl-libdir=#{Formula["openssl@1.1"].lib}
      --with-openssl-incdir=#{Formula["openssl@1.1"].include}
      --with-net-snmp-config=no
    ]

    system "./configure", *args
    system "make", "install", "LDADD_LIBNTP=-lresolv -undefined dynamic_lookup"
  end

  test do
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
