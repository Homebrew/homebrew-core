class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.2.tar.xz"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.8.2.tar.xz"
  sha256 "5c875b8476e05e856ebc8eec458e43317b2bebd6ed5f7725a733d4591548cd9c"

  bottle do
    sha256 "96fe7939ff0bca47146f33368c6ba5470670e9a524ffbc249ddf2307a95ffe4d" => :high_sierra
    sha256 "e56859fb14981cf68ff97d007deb894d05cd1c268c2aca94fded1baac084ed4d" => :sierra
    sha256 "ba0ca7d2a9f6db308701a08f8d39a6a741301f69adc4063d950e7cb66aceeb18" => :el_capitan
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
