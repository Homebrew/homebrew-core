class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.gz"
  sha256 "f3c1102b07eb0e7a50538f9fc9037c18387165bc70d4b626e94ab725b9d4d1bf"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }
  revision 1

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "629a76ecd1a0cab83c01e1bf5488d85515f0115c0a1f638b0aa25dbc9f3146cd"
    sha256 arm64_monterey: "0a4162f4f01767c76acabf13f888dc9a585b3ff72df88545704fad68ce578954"
    sha256 arm64_big_sur:  "c5e80b820d74af67cdd25a7125b423bbe259930d35507aaabd56b82ebaca0048"
    sha256 ventura:        "cce07824ab505a5acc47b5a3db22c3906ca88ab494216dcbba14be7a66e9b51f"
    sha256 monterey:       "4e35b5a5e6f0c0ef134630be137142aecc42a73ce8d9ee1c1df8c7a478dacb7d"
    sha256 big_sur:        "604d0e1beb8fb68b0dcf12b83a2209f34c7d0f9d3fc47c3b9b34222c93faa593"
    sha256 catalina:       "ef38aabd458e85e3cbfb7bfbe1ca96949baad75397a1a4fbb25cdf299a713dfe"
    sha256 x86_64_linux:   "310ccd7518b730389ca3d5162faa9866fc68d023f84c2c24147c7551b990dc9b"
  end

  head do
    url "https://github.com/fltk/fltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "jpeg-turbo"
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
