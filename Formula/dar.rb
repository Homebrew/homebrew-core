class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.2/dar-2.7.2.tar.gz"
  sha256 "973fa977c19b32b1f9ecb62153c810ba8696f644eca048f214c77ad0e8eca255"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "89f145997e301eb51ed6fadbd3c0583113499204f56fdf9032b016c4020fa947"
    sha256 cellar: :any, catalina: "af73f8c79627e84c8d36cb079dfd598d943278f0b73fd68b873f45872124409c"
    sha256 cellar: :any, mojave:   "ef0298ac3f4143f7b15d3ca7a0e2e873d6ee0b28cb1d0066c9ff46e4fd2144a6"
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
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
