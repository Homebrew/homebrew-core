class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.3.tar.bz2"
  sha256 "91bcb0403866b4e7c4bc1cc52ed4c364a9b5414b3994f718c70303f7f765e702"

  bottle do
    cellar :any
    sha256 "6c0dc97e55b5d2808d0a92811bda1d39ca551f91ef390113f9ce4000add4d652" => :mojave
    sha256 "14b3e1d30e73d458639f509d588188d12d4b552512a9f097bc50596c61c0f37b" => :high_sierra
    sha256 "9e3c840f03a517275a5f328e3ca3fd391651e6e3d23a0e22759fea39b4de31bc" => :sierra
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
