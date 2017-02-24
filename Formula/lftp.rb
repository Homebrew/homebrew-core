class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.tech"
  url "https://lftp.yar.ru/ftp/lftp-4.7.6.tar.bz2"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.7.6.tar.bz2"
  sha256 "6b46389e9c2e67af9029a783806facea4c8f0b4d6adca5c1088e948d2fd68ae7"

  bottle do
    rebuild 1
    sha256 "5165aa213ad8474a8bc4a53a1b8373809f95a10496291c4eb16c1949632ff93b" => :sierra
    sha256 "4699e621b243e4af23b6bfde52365e6584321f5cb70b57218b27130f13fdf14e" => :el_capitan
    sha256 "2a1e047fb1dbc8ca8da1269e28ea3aa869848f7c6da76aea17dde80d9138992e" => :yosemite
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
