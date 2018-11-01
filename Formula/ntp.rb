class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p12.tar.gz"
  version "4.2.8p12"
  sha256 "709b222b5013d77d26bfff532b5ea470a8039497ef29d09363931c036cb30454"

  bottle do
    sha256 "68a5e42380f38ebc941864ff5f2cf710d8b23a1ceda7b612996f7bd27fd37d51" => :mojave
    sha256 "d0e19a944a165087388ef43010a9d5407c08a96b461574dedb13b4a0e1a4079b" => :high_sierra
    sha256 "e177b88d4a9bb828bdae90f935fe138ca59eba94c7aafa1ab13bfc65caf0a82e" => :sierra
    sha256 "bd59b6a069f159a7a226f12ac254e41702fb992b2c6763adb9af25e659dd18f3" => :el_capitan
  end

  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl-libdir=#{Formula["openssl"].lib}
      --with-openssl-incdir=#{Formula["openssl"].include}
      --with-net-snmp-config=no
    ]

    system "./configure", *args
    system "make", "install", "LDADD_LIBNTP=-lresolv -undefined dynamic_lookup"
  end

  test do
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
