class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2"
  sha256 "22843a3bdb256f59be49842abf24da76700354293a066d82ade8134bb5aa2b71"

  bottle do
    cellar :any
    sha256 "ee2963ca282ce3c07f7d04e07e13d24ced2945da91cddc13af7daa63d44f31c1" => :el_capitan
    sha256 "6fcc4cac8e6667776d23dd16205798db9c1dcf5033ba20d977ffd98ee6c074da" => :yosemite
    sha256 "c9dfbe5c31ad0afe6371e10b526fd18581b29a9d69fd99cedf826eb4f75485a6" => :mavericks
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
