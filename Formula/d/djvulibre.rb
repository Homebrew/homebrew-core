class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.28.tar.gz"
  sha256 "fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "251aeb1ba6581281a3742cac327422498cc251097f79c56e4b262a4a32f178b3"
    sha256 arm64_sonoma:   "509e80c15c07de6b03d1bf3d729537d0abb30849c55b4aac092f6d760391ad8d"
    sha256 arm64_ventura:  "03c2b8a0fd889f5286436b3b2b1b8b10ceec29ed133756d8bb64ac20f867d0bf"
    sha256 arm64_monterey: "f39559ac1a9d9e3351dcc2d77384875434a8aa7d84406d0f5214dd42e86759e5"
    sha256 arm64_big_sur:  "b2c030948a6296ea93065ac207b7d71effd08a1126abc9a8365186cf4d04bf73"
    sha256 sonoma:         "4a6bb80e8624388a8ec2b760b43908b8dcd45dd317026f0530c8d77a133d7d3e"
    sha256 ventura:        "437c4982f64bf9f3c17d3dc6e07a204770a8028ee924f23ddd0f09af9cd4fbc4"
    sha256 monterey:       "5c208fecddc8a56aae519f38d52a06c2b6f261b094077e05b43cebc9d452f3cd"
    sha256 big_sur:        "d325152b1930974548997efcf819595fefcddd23cebaee2e22718cc3296d1957"
    sha256 x86_64_linux:   "16b50bba79b4dba1593db9633d8a396633e02dd015f5858f19eb8ad9aff3142f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or Quick Look plugins
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
