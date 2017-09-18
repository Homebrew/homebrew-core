class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.1.tar.xz"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.8.1.tar.xz"
  sha256 "e770daa5592ad21bd0b8a8915a0f4fdc2e15dec6c69e754a870ad9c18be57b27"

  bottle do
    sha256 "e56859fb14981cf68ff97d007deb894d05cd1c268c2aca94fded1baac084ed4d" => :sierra
    sha256 "ba0ca7d2a9f6db308701a08f8d39a6a741301f69adc4063d950e7cb66aceeb18" => :el_capitan
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  # Remove for > 4.8.1
  # Fix "error: non-constant-expression cannot be narrowed"
  # Upstream commit from 17 Sep 2017 "Fix build on FreeBSD-i386 [1] (#391)"
  patch do
    url "https://github.com/lavv17/lftp/commit/ee60a0f7.patch?full_index=1"
    sha256 "a45f4ac27f9957839b99742e7d097c632fb4c44cf935ca514410284861d4ac09"
  end

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
