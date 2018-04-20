class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.7.0.tar.gz"
  sha256 "1074e140c537c25f3da63501ebdb80671b770c5078e97aa9970b79d520009541"

  bottle do
    sha256 "eb6bc8c1171c8ee45e50a221b8cfa8acd88677fcfe19a0bba55d93944d605e8b" => :high_sierra
    sha256 "0a1db39a365e60a33c4547a4b2eb67c0560e7085fb53ce277af005f344be2389" => :sierra
    sha256 "6946070150aa1e82d880eec5aebb88abffb689436f95b1209adc8c44c5312760" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  # Remove for > 1.7.0
  # Fix "configure: error: Required function not present"
  # Upstream PR from 21 Apr 2018 "Build with missing pthread_mutexattr_setrobust()"
  patch do
    url "https://github.com/adrienverge/openfortivpn/pull/298.patch?full_index=1"
    sha256 "e70b74e583fdab584bda6be649d5a8853464552b160c132544dac0fe0841eb8c"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
