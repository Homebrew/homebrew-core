class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.0.tar.xz"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.8.0.tar.xz"
  sha256 "7a2880968088b4aeec43b6b6680fef0e065e1dddcce9b409390157e9766b690f"

  bottle do
    sha256 "d27973d0a87c6cb2362be22562ae8082f521c68895a394294219aa2812409d32" => :sierra
    sha256 "cba2c456d098e8d7db989207ba27d383e602b88de78fe25c186932e5be18f6e6" => :el_capitan
    sha256 "5ba5ec09928d5314ec91ce77825b3415f8e323e8812889cb6839d30304fb608e" => :yosemite
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
