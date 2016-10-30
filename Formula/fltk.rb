class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"

  stable do
    url "https://fossies.org/linux/misc/fltk-1.3.3-source.tar.gz"
    sha256 "f8398d98d7221d40e77bc7b19e761adaf2f1ef8bb0c30eceb7beb4f2273d0d97"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/92b5f073bee3ee37c2d6194571c76ce19efdc94f/fltk/patch-CGLineCap.patch"
      sha256 "bfe8e8cf889fcbf3c5fb8bdad7cf7a9fedb92d8b4aa8f40bb9930382bb97d197"
    end

    # Fixes issue with -lpng not found.
    # Based on: https://trac.macports.org/browser/trunk/dports/aqua/fltk/files/patch-src-Makefile.diff
    patch :DATA
  end

  bottle do
    rebuild 3
    sha256 "b84a8a32ac7718099b9b41959b17d0511d0b915230aa28d29bdec5bd38222029" => :sierra
    sha256 "4e1b9e5a401319d74b77aae46a12b2d3da3a2a8e0a50364ac9ac9aadbbf5fb50" => :el_capitan
    sha256 "c2c1f6f6219979cb8864c2afb03ef5aed71b2df6fe232c0b8ad024b2a57d506f" => :yosemite
    sha256 "c9891be771225c5729be4227f7da60ca7d199d90fa868c737bc7f0893f31947e" => :mavericks
  end

  devel do
    url "http://fltk.org/pub/fltk/snapshots/fltk-1.3.x-r11756.tar.gz"
    sha256 "3c0594bdf9043edb2a3b77bcd632ca43ad529404b3d9ae0a1f29f2d60890e4b0"
    version "1.3.3-r11756" # convince brew that this is newer than stable

    depends_on "autoconf" => :build
    depends_on "autogen" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg"

  fails_with :clang do
    build 318
    cause "https://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  def install
    ENV.universal_binary if build.universal?

    if build.devel?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end
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

__END__
diff --git a/src/Makefile b/src/Makefile
index fcad5f0..5a5a850 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -360,7 +360,7 @@ libfltk_images.1.3.dylib: $(IMGOBJECTS) libfltk.1.3.dylib
 		-install_name $(libdir)/$@ \
 		-current_version 1.3.1 \
 		-compatibility_version 1.3.0 \
-		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk
+		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk $(LDFLAGS)
 	$(RM) libfltk_images.dylib
 	$(LN) libfltk_images.1.3.dylib libfltk_images.dylib
