class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.7.0.tar.gz"
  sha256 "1074e140c537c25f3da63501ebdb80671b770c5078e97aa9970b79d520009541"

  bottle do
    sha256 "6400f2fd4f043fa1d0d65c44c312406adab3556ec6e76dbf656b89962c37f0fe" => :high_sierra
    sha256 "f661312441810d63c3ab98707b41dcbd66ad78e692a26448e22350ea9a51f780" => :sierra
    sha256 "e420bab72c33b7490870afb2f3595b06bb14989ea916e63c337e94a8ec841d88" => :el_capitan
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
