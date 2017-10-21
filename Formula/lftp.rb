class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.3.tar.xz"
  sha256 "de7aee451afaa1aa391f7076b5f602922c2da0e05524a8d8fea413eda83cc78b"

  bottle do
    sha256 "699cbe616307d318e21e36f2665d5f6acfa616b194d9dd998feb977be61694af" => :high_sierra
    sha256 "b9bdd2db27e79ac0fe39ac583fa2734f4296303a5f46d9f7a953122829643f75" => :sierra
    sha256 "1bfc8491a2ff1103daf12a5b4c16f6f0b897c830d4cff85002db8bb0e1e14313" => :el_capitan
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://ftp.gnu.org/; ls"
  end
end
