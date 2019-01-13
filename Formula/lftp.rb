class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.4.tar.xz"
  sha256 "4ebc271e9e5cea84a683375a0f7e91086e5dac90c5d51bb3f169f75386107a62"
  revision 1

  bottle do
    sha256 "e83b0fd55753659041be1d6b9ee8f299af011a371eb9114056981f3144a3e305" => :mojave
    sha256 "9c430819daed7f22aed2aa8968ac5706ec546bf16b4427a49a699f2391fce010" => :sierra
  end

  depends_on "libidn"
  depends_on "openssl"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
