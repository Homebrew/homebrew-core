class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.5/turnserver-4.5.0.5.tar.gz"
  sha256 "8484fa6c8d4aab43e1161c02eb8914154a21178b05f8a285e04094ddbb64acf4"

  bottle do
    sha256 "d22be2c9222767571e4e403a0ba8c266ea652e2bf1c2918c5ed6ed898f294487" => :sierra
    sha256 "62285eafa40f83258f64f6b7c1c4d4c68059ab2c65a6694f079016e02b85c844" => :el_capitan
    sha256 "a3dd8d3fda712808836c07391e7e2e6ce5d308d3dffe69266daf45426e4fccff" => :yosemite
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
