class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"
  url "http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.4-2.tar.gz"
  version "1.3.4-2"
  sha256 "25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910"

  bottle do
    sha256 "7561987fff4639d07a28407b8d4f511fffe4579fb452a0aaa9dad2f0a0bde48d" => :high_sierra
    sha256 "1fbd79e3f5c36f70cc5f2d0256520fd8c6ee969990412cb9080eacfe9e75e4a1" => :sierra
    sha256 "fca842e5e25fc0a0566d64b3d34226e667f072f82cd51f009180a09db218666b" => :el_capitan
    sha256 "bb481cbaefe696696c3bf527b4902b8251de3ee7c75619f89fd554a6e73b1b40" => :yosemite
  end

  depends_on "libpng"
  depends_on "jpeg"

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
