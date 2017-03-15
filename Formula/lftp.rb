class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.tech"
  url "https://lftp.yar.ru/ftp/lftp-4.7.7.tar.bz2"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.7.7.tar.bz2"
  sha256 "fe441f20a9a317cfb99a8b8e628ba0457df472b6d93964d17374d5b5ebdf9280"

  bottle do
    sha256 "ce6de0c8cad4501507b47457b9fcaa08048f82db0ed4ea6ad42a5901f6aecffe" => :sierra
    sha256 "ea3c52aa05979ca8e68ca44dd94d61c6f91a040df90fb64ddc52e5f92c2c7a95" => :el_capitan
    sha256 "049f0d2fb6a75d4ae7d4a9b02242cc286307d11b23793793879a2644263d7268" => :yosemite
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
