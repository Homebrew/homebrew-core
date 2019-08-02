class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz"
  sha256 "e020ce90ea0301213451d37099185ff25d93f97fa0f2b48bf21b2946fc3696a4"
  revision 1

  bottle do
    sha256 "0965e2d618dc990376fe852dc24c748a789c320381c3d935f8f557ce30df9304" => :mojave
    sha256 "64d8d65360234067a875bc90db41ab69127641f847c1450a2f0cc71869de20a1" => :high_sierra
    sha256 "9813765ffeb2d1dbb8738a8695ef34473fadec04307561791856de68feea7e03" => :sierra
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
