class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://gitlab.gnome.org/GNOME/gxml/-/archive/0.20.3/gxml-0.20.3.tar.bz2"
  sha256 "22d8ed0f9f6bc895c94c74bfcd6f89f64aa96415c19e1b648277df70b4ed20f7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "8656553f20776f1cbfeac041d7a7aa21c88bf9237d49162cb76f3613dd023e25"
    sha256 arm64_monterey: "004caf23ceb17a3c71ffb2b85879ef3d6bf85cb207d517f70c17edc5ba8821aa"
    sha256 arm64_big_sur:  "4980c9844514c1ff646da64e64b728c0fddd14ce2a1c8262fc00a59429b10a37"
    sha256 ventura:        "53d420b85af3e0e77aa517f66f731e1ff8f4c3f32cebc8acdff3ebf15e4ae97d"
    sha256 monterey:       "1d892844ac448f58ecb5ef283a66de0d79112686a19963351c2136b28b483821"
    sha256 big_sur:        "3a83e6b4ed0bfc8a4a869b13c9dc3573ab168ce39c9d625074c27d80615b7716"
    sha256 x86_64_linux:   "59390a8cce6b9d523c93f9b4ceca1ab1bca8f8d83c35fd6f4d015319d5a9b055"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dintrospection=true", "-Ddocs=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    icu4c = Formula["icu4c"]
    libgee = Formula["libgee"]
    libxml2 = Formula["libxml2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{icu4c.opt_include}
      -I#{libxml2.opt_include}/libxml2
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gxml-0.20
      -I#{libgee.opt_include}/gee-0.8
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{icu4c.opt_lib}
      -L#{glib.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libxml2.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgxml-0.20
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
