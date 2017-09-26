class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.2.tar.xz"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.8.2.tar.xz"
  sha256 "5c875b8476e05e856ebc8eec458e43317b2bebd6ed5f7725a733d4591548cd9c"

  bottle do
    sha256 "e7d293c56895ce31f0494a5f1e71123bbf09b436af4411c65d905cf2d6bb28ac" => :high_sierra
    sha256 "8440982326763f2c3c92289f29f85f81854818e779cd0e43e989cb20e0e2e046" => :sierra
    sha256 "e0c7e12f05d596b6c74e9b564300a8b0739e5ab8b5ba2c89f55730fde917b386" => :el_capitan
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
