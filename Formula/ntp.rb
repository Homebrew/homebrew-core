class Ntp < Formula
  desc "Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p15.tar.gz"
  version "4.2.8p15"
  sha256 "f65840deab68614d5d7ceb2d0bb9304ff70dcdedd09abb79754a87536b849c19"

  livecheck do
    url "https://www.ntp.org/downloads.html"
    regex(/href=.*?ntp[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "56e2b28056f17d7650a305bfae1725adcff788bdfe53abde908c163fcc02ddd4"
    sha256 cellar: :any, arm64_big_sur:  "5aaceeca360143de4591c0294ed75755f50c14cfcdb908b7c1622fa5caa22cf4"
    sha256 cellar: :any, monterey:       "dc79526c62d10033e35cc0d16bb2f138c05577dd8f5de7289836a6e31f75d6a3"
    sha256 cellar: :any, big_sur:        "cee6250b029cdb17a3e7c8f68ec6bf16a3a3751bea52a758bca885932e5a0de4"
    sha256 cellar: :any, catalina:       "3c6a8893b0e76b8af1a4fd19ab664279b5409c1129062bf1feee4643318236b3"
    sha256 cellar: :any, mojave:         "b69ded37b2c8304157c3f46e4484af9099b4fd1e077929c35bb630903d059856"
    sha256 cellar: :any, high_sierra:    "9f7ce9c3ff545ff738fcf4049445923c968ec807cf1ecde451be76412442e6f1"
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
