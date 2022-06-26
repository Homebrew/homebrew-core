class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.gz"
  sha256 "f3c1102b07eb0e7a50538f9fc9037c18387165bc70d4b626e94ab725b9d4d1bf"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4c22c41979d57ab6dd11402ee65d16c13f5b8c8aefc380b3b6df86c8c352726a"
    sha256 arm64_big_sur:  "cac2d0addf36697d05e1f727abab20bc7eebd7d0e7164e9a165e22114016ae26"
    sha256 monterey:       "eabc4609af02c26d7e5f7470740063ed57bf8ab9c7b53cc5ff9aaca7d836863a"
    sha256 big_sur:        "2228c7c23d137b575906abd07f10d54dd232cd3aa89565d69ac6b943134b8854"
    sha256 catalina:       "b17355d7368662d2fb883651f82647f9e84db9f7e0766d833ffd4f10c7780fdb"
    sha256 x86_64_linux:   "78cdc8e6ef47cc3406dc4cbd5ccf76dd564ecb4914e23876d01862d2421ce56f"
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
