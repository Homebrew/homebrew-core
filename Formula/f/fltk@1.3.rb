class FltkAT13 < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.10/fltk-1.3.10-source.tar.gz"
  sha256 "c1c96d4f2ca7844f4b7945b4670aff2846f150cd5f3e23e3e4c70a61807108c7"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(1\.3(?:\.\d+)*(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "42137ae37ed975c86cf8dfae5fa052ecf9cd9e07a0f4719da35e0bffb95f555e"
    sha256 arm64_sonoma:  "96d8e718dbef7557ff0fd302420ce4ffd1fd3fe0ed3178c6eca3bbdaaeb5b776"
    sha256 arm64_ventura: "4e025d394e75457fa5aea55ea1e0ac47df89c6c1fe1cc9b6fd5e4ed5de99eea1"
    sha256 sonoma:        "d44bc567d2045088a4f9ebde2fdcc606fb05d21726de5abe836eee74ce3cef4e"
    sha256 ventura:       "f31586117b37b2bb707bbea3037270805dc5982e4fed54d7b6b59c51c144a612"
    sha256 x86_64_linux:  "695b8822888b50a7989144daca06fa371d3aa9bd47026009d35fb40885cf44d1"
  end

  keg_only :versioned_formula

  depends_on "jpeg-turbo"
  depends_on "libpng"

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
    args = %w[
      --enable-threads
      --enable-shared
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
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
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
