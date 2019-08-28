class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.2.tar.gz"
  sha256 "e1ec2f43036ba639743d631f308419c9a88618a93d4038bf40a9cdeef89ca6db"
  revision 1

  bottle do
    sha256 "006db27f7e6d2370e6a5e318c5c5eb0105c1dd5092c0fe397b0c9196d7298432" => :mojave
    sha256 "c77151aad876b68e731ac2f63ea6ca661f95e0e1e603a0c081f0d7a6d5c110c2" => :high_sierra
    sha256 "dcd51390cdf902d90e1c9f21b67f4a38a4b470d4bd8b7e1190c40d0df6641377" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
