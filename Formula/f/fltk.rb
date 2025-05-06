class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://github.com/fltk/fltk/releases/download/release-1.4.3/fltk-1.4.3-source.tar.bz2"
  sha256 "76ecc922b6d708f75ab29abe2810494575b66b00735e692cff6d96686ed0fc4a"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "938a50ae988efbb07d3975c992a47b4f696be0a28635496c565e725ecaa7fb39"
    sha256 arm64_sonoma:  "7b9f54c0bb23c4eda241d34fd807698e20d7a9654e9d879ed2e52297a173b6b5"
    sha256 arm64_ventura: "d0e1ecf48f53ce925ba57a1c26719de8769196e28d9ba19a8ceab5769251976f"
    sha256 sonoma:        "604d447081fe46632730bb4a33b6758c9d87fca421662198d1756cc55de13184"
    sha256 ventura:       "f78d210049fe429633dc6815be381af85b6c6911df8ca39eaf50bd091a7fb0fc"
    sha256 arm64_linux:   "33c4d377b9ababaad8209c598c2db0451aed544c04dfc23715bad0f8fa269d5e"
    sha256 x86_64_linux:  "08732bbef64880963a6ba5d27bf117c1e824f49c9df5eb1850d08f43ab3cb13d"
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
