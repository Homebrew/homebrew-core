class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  revision 3

  bottle do
    cellar :any
    sha256 "fce5577098322a2b4f6fd73a4a18077f77100adf1f15d9a494594e416354d1cc" => :high_sierra
    sha256 "cc01e2bcdd26e6e9b0852e604f2bd56c31bde00ff42eb73fca45d2661fbab159" => :sierra
    sha256 "aa76cbdcef93ac7d4af39b9cbcb1b841fa08f2dd11cf7542c5fa4f4ae365b0cc" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  def install
    system "cmake", ".",
                    "-DLIBZIP_INCLUDE_DIR=#{Formula["libzip"].lib}/libzip/include",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/einfo", "-help"
  end
end
