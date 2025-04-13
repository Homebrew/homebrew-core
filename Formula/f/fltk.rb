class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://github.com/fltk/fltk/releases/download/release-1.4.2/fltk-1.4.2-source.tar.bz2"
  sha256 "26aa9626614fd6f30fd8694c89cd4ea7606a1347230a34615f900dcf6f8f4899"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0aeaee90cdf8642db8dac95c16e34e9212361d060aafc6ce6b0f12877e2a4a49"
    sha256 arm64_sonoma:  "28d869d6be160a32c1ea1bf581a7abd05797836f596f6b08b793a0afee6c7646"
    sha256 arm64_ventura: "08c52f3d4fa9dd9561f04966786dcef01e727ad09066d6e60edb590a01e08259"
    sha256 sonoma:        "1c8b484190d81723d1fb453ac0013723d8155e6904360c1902e24a12fdc6009c"
    sha256 ventura:       "776014086cd0a0ecde33292222db57e9ee71045e7fcde841cbc4ad2cb0a5352e"
    sha256 arm64_linux:   "c3864b43d5c3ef8d5858f0113a6c75950dd65518153313da8cc22844677db015"
    sha256 x86_64_linux:  "f2c5316d9e488984ecd326b290db0bb577b47cf7a1a8e16542fe6d0fe4404a1f"
  end

  head do
    url "https://github.com/fltk/fltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "mesa-glu"
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
