class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz"
  sha256 "e020ce90ea0301213451d37099185ff25d93f97fa0f2b48bf21b2946fc3696a4"

  bottle do
    sha256 "daaa92dccec4095cc801e36318cd63dd64ab31626a21b46f4ba323766aad93b2" => :mojave
    sha256 "8f556656bccc21c5042b1fad00b6242ea783851a00141aa8cb54ff0e12cbb4fe" => :high_sierra
    sha256 "5debb5ffa15e2ecd75b14a79d4077cd2d4b47520c282033507286953226aeda0" => :sierra
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
