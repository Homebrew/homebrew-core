class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz"
  sha256 "e020ce90ea0301213451d37099185ff25d93f97fa0f2b48bf21b2946fc3696a4"
  revision 1

  bottle do
    sha256 "40ae9111624e581b825f1fb3a7701512f1b8bf86d26ca17c59e5e9d673cd3270" => :mojave
    sha256 "d332b25b9dadedce62e40bf10d10d82784bdfb049ca7936b9db2fc8ef6110e17" => :high_sierra
    sha256 "2b2ef532930f01cf3b5a2deb3d22e0f706e19febfb60dd8e5ef270f6a2000d12" => :sierra
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
