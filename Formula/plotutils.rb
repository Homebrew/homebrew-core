class Plotutils < Formula
  desc "C/C++ function library for exporting 2-D vector graphics"
  homepage "https://www.gnu.org/software/plotutils/"
  url "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "edab5b91771162c1783dc69482834de6a2ca0fd077ea83b79d1934a365f7276d" => :catalina
    sha256 "96a618ea8123f08d676b0db38c1c3b93dc8f707c742e97442b74650c2dd8e4c5" => :mojave
    sha256 "00796c7f6aa36203eb0fd919ef4f096c6016d3c5973b2032328c95c87b354d92" => :high_sierra
    sha256 "b63f4f051452f8fd9b5ddb50f9d574122c2277c9778e1a56c3f2d59e55c3da73" => :sierra
    sha256 "b734cdcbc7ce11c4a716bc96ee7671f3883a5d41dadceac28d994ad2c20292f9" => :el_capitan
    sha256 "fae89f252628820ac83a0896fa022b1c08cacca6e6234b2fb23c10554f424fd3" => :yosemite
    sha256 "e51b4b5c367e8f9ec533f54e20c9df0b887818ee35c4cde19ba8feb73d4d2ff2" => :mavericks
  end

  depends_on "libpng"

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace "libplot/z_write.c", "png_ptr->jmpbuf", "png_jmpbuf (png_ptr)"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-libplotter
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/graph -T ps", "0.0 0.0\n1.0 0.2\n").start_with?("")
  end
end
