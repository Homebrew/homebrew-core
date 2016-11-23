class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"
  url "https://fossies.org/linux/misc/fltk-1.3.4-source.tar.gz"
  sha256 "c8ab01c4e860d53e11d40dc28f98d2fe9c85aaf6dbb5af50fd6e66afec3dc58f"

  bottle do
    rebuild 3
    sha256 "b84a8a32ac7718099b9b41959b17d0511d0b915230aa28d29bdec5bd38222029" => :sierra
    sha256 "4e1b9e5a401319d74b77aae46a12b2d3da3a2a8e0a50364ac9ac9aadbbf5fb50" => :el_capitan
    sha256 "c2c1f6f6219979cb8864c2afb03ef5aed71b2df6fe232c0b8ad024b2a57d506f" => :yosemite
    sha256 "c9891be771225c5729be4227f7da60ca7d199d90fa868c737bc7f0893f31947e" => :mavericks
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
    (testpath/"test.cpp").write <<-EOS.undent
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
