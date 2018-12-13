class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.4-2.tar.gz"
  version "1.3.4-2"
  sha256 "25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910"

  bottle do
    sha256 "fbf193393bb8d95b303e3e9bdda7b7808c8211b06ec76017ef386f3dac3ca8aa" => :mojave
    sha256 "5dd4bbb5cf10af5e0a1ff2f29c6d12657f09626fab43811b441b27c677afd0af" => :high_sierra
    sha256 "e22929035ced94a301c1294de6d305079e34d9709d3e9551b19555ab2f06656e" => :sierra
    sha256 "5481ffce354c2c98ed7634b036d678c7476780085e1a518af186f2e4b22d2c31" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "libpng"

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
