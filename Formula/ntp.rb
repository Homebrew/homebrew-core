class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p14.tar.gz"
  version "4.2.8p14"
  sha256 "1960e4f081f6aafd108d721bc3ab15f9e8dfd08dc08339aa95bca9d2545e4eb7"

  bottle do
    cellar :any
    sha256 "ab0e452c294590e48d80f2905b8088c4ec393d4e0fd5e53e260667c67634ccf4" => :catalina
    sha256 "281e84d4a074ddb75937e9f6a1e5b58502e79c4255dc5c5ee2c9e0f9117f78b4" => :mojave
    sha256 "3369881e6bff45235eb11c23a034247a63dfb16077d5a8ecaeea2aca59866fbc" => :high_sierra
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
