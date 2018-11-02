class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p12.tar.gz"
  version "4.2.8p12"
  sha256 "709b222b5013d77d26bfff532b5ea470a8039497ef29d09363931c036cb30454"

  bottle do
    rebuild 1
    sha256 "0ad5a4953a1fc2598b0fee4ed85fdb61e62d6acd1c7a80aa8ba448cfd829e908" => :mojave
    sha256 "00a29bdce9bc82c18aa824693146f8c0674af3ca8bef3f42f63c87ab5bd4aa02" => :high_sierra
    sha256 "a37c6e3e17a8862d770e2f27a399d85198a68f88a592234db55fd80e06ff9cee" => :sierra
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
