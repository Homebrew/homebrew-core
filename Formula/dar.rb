class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.16/dar-2.5.16.tar.gz"
  sha256 "e957c97101a17dc91dca00078457f225d2fa375d0db0ead7a64035378d4fc33b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d643ec441c9ed7da176da5ce56413c918b7cad23d5ae6cd995766698461aa26" => :catalina
    sha256 "3009db4f526f3657c3008475df42b5e1759ad9964c513f541de3c3c05e971ffb" => :mojave
    sha256 "b872b6741e38ea818e1836fd218733331219c15acfb84a638dc213eec8925f6e" => :high_sierra
    sha256 "263659de5c6418cadae4d2bbe71c4b45c14d7d5e91ae1fa62a8e2c7e8b3a2fd5" => :sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
