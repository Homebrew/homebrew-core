class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.4.tar.xz"
  sha256 "4ebc271e9e5cea84a683375a0f7e91086e5dac90c5d51bb3f169f75386107a62"

  bottle do
    sha256 "049adb818e22dac728fd354bd1c52e8feda8fdcfc1366819ede44904e1d8e01a" => :mojave
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
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
