class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.1.tar.bz2"
  sha256 "47f96c37b4f2aac289f0bc1bacfa8bd8b4b209a488d3d15e2229cb6cc9b26449"

  bottle do
    cellar :any
    sha256 "368befb6f17abddc5ab82c6f0357c627bdbc7dd6f5b728f7bdfd0379ee85633b" => :high_sierra
    sha256 "ee7df89419fde3e577ab562cf7c5f6c433602c69db2c6f8953f2e4a98b94d571" => :sierra
    sha256 "2a6c458d07cd73d0758a112ac157cd32c7a408e46d6d2cff9d1a65ef1f989a96" => :el_capitan
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
