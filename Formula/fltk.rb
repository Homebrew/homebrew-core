class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.4-2.tar.gz"
  version "1.3.4-2"
  sha256 "25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910"
  revision 1

  bottle do
    sha256 "d4844065f8c9fb37183d610d4c0d55d1dc3447d7348ab34930d1e6e35c7f21c7" => :mojave
    sha256 "06b17cb9b3c89f4e5df09eacb7f735af872bdec7fb1932237c83ba72be1a680d" => :high_sierra
    sha256 "c5b58949cc184e7af5fd44fbfc65a71a37e2fc950bb08971c6fb633d85eccabc" => :sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  # Fix for Mojave issue https://github.com/Homebrew/homebrew-core/issues/33342
  # Modified version of upstream commit https://github.com/fltk/fltk/commit/f76d2a2bf8c35c0c313f05bbd6deda49dd344efc
  # Remove after next release
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a68bce/fltk/mojave.patch"
    sha256 "9483adfc70c25bd560c4400972d8d12d288ee78c27b1c03c965aa59818e59152"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
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
