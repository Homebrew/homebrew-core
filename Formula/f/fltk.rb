class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://github.com/fltk/fltk/releases/download/release-1.4.4/fltk-1.4.4-source.tar.bz2"
  sha256 "2b302c80b7ea937a8bdc01ed6718fd995035bf63e9a2895491c1001821725f1f"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a336acc1290d177f51ff0ebeb70d0eacd45bf5b473489d2bb5af6df720fde6f4"
    sha256 arm64_sequoia: "0dd518fec8c5774ca8b2d886befbc3a984b229ebcbe476adad4d695214b58425"
    sha256 arm64_sonoma:  "822945c549971421e1aac934c817240d42c2b0edcf5e4113faa6901158ece222"
    sha256 sonoma:        "870d5060045c0116ae47372a0229db2864d61ee1f765126c93650bc739963b39"
    sha256 arm64_linux:   "1f960238c43d81c044200cb4a00950b1f764c4d150c4754e43c312243540334d"
    sha256 x86_64_linux:  "a90426f91678df9321e01dc8dcaea265da0725dd05975aa7cf6be6da7bc7cf14"
  end

  head do
    url "https://github.com/fltk/fltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      args = [
        # Don't build docs / require doxygen
        "-DFLTK_BUILD_HTML_DOCS=OFF",
        "-DFLTK_BUILD_PDF_DOCS=OFF",
        # Don't build tests
        "-DFLTK_BUILD_TEST=OFF",
        # Build both shared & static libs
        "-DFLTK_BUILD_SHARED_LIBS=ON",
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      args = %w[
        --enable-threads
        --enable-shared
      ]
      system "./configure", *args, *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
