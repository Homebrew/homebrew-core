class Plotutils < Formula
  desc "C/C++ function library for exporting 2-D vector graphics"
  homepage "https://www.gnu.org/software/plotutils/"
  url "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b9cb22e1853063ad3da1d788c15166565b20533ea54484dcca6311839795f6e4"
    sha256 cellar: :any,                 arm64_ventura:  "0f7f764c7ed45dcf462cc30ec41ea6d9439060145bd7b3ee3770c38b8c5adfaf"
    sha256 cellar: :any,                 arm64_monterey: "e20de0661d2b4bed5cd649ac4bc113f652642d539be2cc3a806dc3d991e08ae8"
    sha256 cellar: :any,                 arm64_big_sur:  "df2133fa4e5dd7c50d8145c3960afd6a75e1ff6e5d9e3255ff03cea00ddfdab6"
    sha256 cellar: :any,                 sonoma:         "cf4be8e3f730ac440f962c7b586b5265933121ed6d94c4dc675e9a355b8909ba"
    sha256 cellar: :any,                 ventura:        "5b899b62f779098696d71a54ddba9ed0307110b9f04a21f6a7c11f65d777842a"
    sha256 cellar: :any,                 monterey:       "3ee9b41dfac9fef4f67c7cc09a10cc9ded3337ff31e1bcd3ddab89ab997f82ea"
    sha256 cellar: :any,                 big_sur:        "3ca14b49804af8b7364087731097dc992816d16a82fb6da2afeae18c1772e886"
    sha256 cellar: :any,                 catalina:       "edab5b91771162c1783dc69482834de6a2ca0fd077ea83b79d1934a365f7276d"
    sha256 cellar: :any,                 mojave:         "96a618ea8123f08d676b0db38c1c3b93dc8f707c742e97442b74650c2dd8e4c5"
    sha256 cellar: :any,                 high_sierra:    "00796c7f6aa36203eb0fd919ef4f096c6016d3c5973b2032328c95c87b354d92"
    sha256 cellar: :any,                 sierra:         "b63f4f051452f8fd9b5ddb50f9d574122c2277c9778e1a56c3f2d59e55c3da73"
    sha256 cellar: :any,                 el_capitan:     "b734cdcbc7ce11c4a716bc96ee7671f3883a5d41dadceac28d994ad2c20292f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b0edefd4bc7eb703cf1579159b7d746502c77538f58b981405c1cf9ba6d042"
  end

  depends_on "libpng"

  on_linux do
    depends_on "libxaw"
  end

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace "libplot/z_write.c", "png_ptr->jmpbuf", "png_jmpbuf (png_ptr)"

    # Avoid `-flat_namespace` flag.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-libplotter
    ]
    # Prevent opportunistic linkage to X11
    args << "--without-x" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/graph -T ps", "0.0 0.0\n1.0 0.2\n").start_with?("")
  end
end
