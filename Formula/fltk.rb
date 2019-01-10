class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.4-2.tar.gz"
  version "1.3.4-2"
  sha256 "25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910"
  revision 1

  bottle do
    sha256 "fbf193393bb8d95b303e3e9bdda7b7808c8211b06ec76017ef386f3dac3ca8aa" => :mojave
    sha256 "5dd4bbb5cf10af5e0a1ff2f29c6d12657f09626fab43811b441b27c677afd0af" => :high_sierra
    sha256 "e22929035ced94a301c1294de6d305079e34d9709d3e9551b19555ab2f06656e" => :sierra
    sha256 "5481ffce354c2c98ed7634b036d678c7476780085e1a518af186f2e4b22d2c31" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "libpng"

  # Fix for #35682 by pulling upstream patch.  Can remove after next upstream release.
  # patch is modfied version of https://github.com/fltk/fltk/commit/f76d2a2bf8c35c0c313f05bbd6deda49dd344efc
  patch :p0, :DATA

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

__END__
--- src/Fl_cocoa.mm.orig	2017-09-14 12:42:23.000000000 -0700
+++ src/Fl_cocoa.mm	2018-10-10 23:04:17.000000000 -0700
@@ -3301,14 +3301,11 @@
   fl_window = i->xid;
   Fl_X::set_high_resolution( i->mapped_to_retina() );
   current_ = this;
-  
-  NSGraphicsContext *nsgc;
-#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
-  if (fl_mac_os_version >= 100400)
-    nsgc = [fl_window graphicsContext]; // 10.4
-  else
-#endif
-    nsgc = through_Fl_X_flush ? [NSGraphicsContext currentContext] : [NSGraphicsContext graphicsContextWithWindow:fl_window];
+  NSGraphicsContext *nsgc = through_Fl_X_flush ? [NSGraphicsContext currentContext] : [NSGraphicsContext graphicsContextWithWindow:fl_window];
+  if (!nsgc) { // this occurs on 10.14 when through_Fl_X_flush==0
+      [[fl_window contentView] lockFocus];
+      nsgc = [NSGraphicsContext currentContext];
+  }
   i->gc = (CGContextRef)[nsgc graphicsPort];
   fl_gc = i->gc;
   CGContextSaveGState(fl_gc); // native context
