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
    sha256 arm64_tahoe:   "78834ef0a76764d4f0a97ee134b3b735411ab65114e32ca424af71c32f3e2fd3"
    sha256 arm64_sequoia: "67c740f8dd7bd9aca43770e9d31c7533c1d24119dde12a4581c11b2ee90dcb28"
    sha256 arm64_sonoma:  "9beba383d00e8b203de0265b1199ff7a6bc2ffb143d0af6e9cecf51f871a4140"
    sha256 arm64_ventura: "2509089cec05f527863a03b70bdfafeba0d656fc544199d2e73d07b372e95a46"
    sha256 sonoma:        "064e2bcd5bf2bce621e47fac88d54a52707b903ffcbf7bb85cbc0fd55638f741"
    sha256 ventura:       "ca9f056cb372e3db16744210806cc65c791119461f24559502d6be3023cda27a"
    sha256 arm64_linux:   "d1c8f9e9a746cdfca434c02228b459c68258243b1f8b592d7f478b63f0bfdc05"
    sha256 x86_64_linux:  "a7ea283b0880571415192ad1e7a75aa77f62a8e981d6d4f3713091b65a034c64"
  end

  head do
    url "https://github.com/fltk/fltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  uses_from_macos "zlib"

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
