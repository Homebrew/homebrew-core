class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.3.tar.bz2"
  sha256 "91bcb0403866b4e7c4bc1cc52ed4c364a9b5414b3994f718c70303f7f765e702"

  bottle do
    cellar :any
    sha256 "fdb97ce031f3a56e224954c61e8e9f52698c04647ca0251f8ffe54ae27610a23" => :catalina
    sha256 "58154be6004de3e0f731f7b3d7e46060b1f2af831ba81cc15c8b4d8a87dda784" => :mojave
    sha256 "e6f59decc3a0dbabee93e47facd44fde55397865ced49a7c9a2974e49a38ea3e" => :high_sierra
    sha256 "ce29b5468c93eeb9a03ee82272aa89695579c275d00044e21043086a57dd93ec" => :sierra
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
