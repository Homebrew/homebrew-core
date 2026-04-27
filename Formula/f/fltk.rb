class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://github.com/fltk/fltk/releases/download/release-1.4.5/fltk-1.4.5-source.tar.bz2"
  sha256 "b5a52489b7ffae196db2076adb4c1b18170db0d047f5e93539a382603461564b"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }
  compatibility_version 1

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "486b747ce5c87b2e0292feb5f9556090388f70ca4697d2ea5165c886f765ffc6"
    sha256 arm64_sequoia: "9e50dae565ef381c5ea41fd176c1ece2190d8666983d745f4ad4d7efb86c8d4b"
    sha256 arm64_sonoma:  "44c9423e04fb4c95e8ab18c1bd7f6cac703147bfabc7f6c4178e58518bd6eb09"
    sha256 sonoma:        "a0d0ca4dfee32a2dd64d3870bda0d3b328b17ff8410873f0b67c009902ca36ce"
    sha256 arm64_linux:   "7f08bf92d754478f35e14695914c71299086a4d0af59c8faff0353bdefd2d30d"
    sha256 x86_64_linux:  "1d3997c559d56c76ab5e82cadcf5cac020a901c33f302b1c0b2246af7dbca31a"
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
