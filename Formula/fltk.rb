class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.7/fltk-1.3.7-source.tar.gz"
  sha256 "5d2ccb7ad94e595d3d97509c7a931554e059dd970b7b29e6fd84cb70fd5491c6"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "254bcf9ef390fd486067914f90841c0abb2c863de1d245bd4f78997f64bd52eb"
    sha256 arm64_big_sur:  "ef093c6e98b952c2e3393e124e325ad67a038a08f0ee3d88ca7c6a7b07480567"
    sha256 monterey:       "745b3f942ec06b482727b81a15da86e938eb82ed6bec27c03055c51b26db8eba"
    sha256 big_sur:        "d95e5a1b0dcc2537f1ac2964a348728e4a66e774f1aed1f0f5dc84a2f5564430"
    sha256 catalina:       "691edcc9f9c48a7c5ebaba813719ef4a9bb66dae228be3a2f4ed6d29acf17dea"
    sha256 mojave:         "550f4a444fd0b0682c154745c5a1b780ce003a3477afaa9ae25a8a846fa05900"
    sha256 x86_64_linux:   "fa662dc910b37675897d8bee50f77ea1de928f594733f4c4df7f3b4627310486"
  end

  head do
    url "https://github.com/fltk/fltk.git"
    depends_on "cmake" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxft"
    depends_on "libxt"
    depends_on "mesa-glu"
  end

  def install
    if build.head?
      args = std_cmake_args

      # Don't build docs / require doxygen
      args << "-DOPTION_BUILD_HTML_DOCUMENTATION=OFF"
      args << "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF"

      # Don't build tests
      args << "-DFLTK_BUILD_TEST=OFF"

      # Build both shared & static libs
      args << "-DOPTION_BUILD_SHARED_LIBS=ON"

      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    else
      system "./configure", "--prefix=#{prefix}",
                            "--enable-threads",
                            "--enable-shared"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
