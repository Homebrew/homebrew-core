class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.5.tar.bz2"
  sha256 "294a690c1f537b92ed829d867bee537e46be93fbd60b16c04630fbbfcd9db3c2"

  bottle do
    cellar :any
    sha256 "b75192b1cfa25b8d0c61525e1a3333a1574f68b8ecbbb6006d0dcf5af38a4770" => :sierra
    sha256 "97a9bd2af91b311445605e77fdb9452a2c432e53c7e14028391b4d8e770f2514" => :el_capitan
    sha256 "ad02061ff36a845c25a271924b562973ec3c6bb21845c0b0baa5bf5fe703416a" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
