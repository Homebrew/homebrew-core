class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz"
  sha256 "e020ce90ea0301213451d37099185ff25d93f97fa0f2b48bf21b2946fc3696a4"
  revision 1

  bottle do
    rebuild 1
    sha256 "ea728a3a9a8e41d7d8cc4c932fc7c51c574cbb544cba65b26c50e504bb190462" => :mojave
    sha256 "7b90560c6b587da74172abb913f2ef3a2913b0031cce27938f535e3993d60a99" => :high_sierra
    sha256 "5e626ead563c9e282041b7b9bee70d24a8beab8fa227ef336d80cd6858e7635a" => :sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
