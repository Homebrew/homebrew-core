class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.6.10/dar-2.6.10.tar.gz"
  sha256 "16a0b755c648c4ce6598e258ccf375f55d4f2f943448341ed41085ac7a27d2e7"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "715d4c42deee8466b4c4ca1eb5c1eb0e353531f008162a1caa0ac3cebed80eea" => :catalina
    sha256 "da4e6447538509a0cf9b67cd126096ff8b4967ea9503681d8a985b557128cd1a" => :mojave
    sha256 "589731424a6eb153ea8ad9f60e05f18e077194c7ca5d95784bd102bb7781652b" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on macos: :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

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
