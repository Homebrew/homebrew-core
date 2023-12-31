class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.9/fltk-1.3.9-source.tar.gz"
  sha256 "d736b0445c50d607432c03d5ba5e82f3fba2660b10bc1618db8e077a42d9511b"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "91c7ccb23fdc7ee40d62179d011655dcf4101a524d15378a8eab10b6cdd2479f"
    sha256 arm64_ventura:  "c5b71477f972a83b169634cda2e0dd9ad1cc7a050c4fc9e7e67e2ef67f9a30dc"
    sha256 arm64_monterey: "ce76c6264a6b286c50effde7467af19277f3aa6687ea3defb5a73f0152753652"
    sha256 sonoma:         "b9bb01de6143df249171a3222ac987e5f767e87a917cbde3a94b5f63e481314c"
    sha256 ventura:        "d3445b029cec2eec979b6b64478c388759c1950cf69d3b0b8ce89aa3711d954f"
    sha256 monterey:       "f974455eeeebd4968b82146f20259634e5eea0e3f66f93a568cb0526bbadea9e"
    sha256 x86_64_linux:   "140c36c48ef05474e89989556e188b4993d89a770fd74ad6166f640d5be40872"
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
