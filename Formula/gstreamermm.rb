class Gstreamermm < Formula
  desc "GStreamer C++ bindings"
  homepage "https://gstreamer.freedesktop.org/bindings/cplusplus.html"
  url "https://download.gnome.org/sources/gstreamermm/1.10/gstreamermm-1.10.0.tar.xz"
  sha256 "be58fe9ef7d7e392568ec85e80a84f4730adbf91fb0355ff7d7c616675ea8d60"

  bottle do
    cellar :any
    sha256 "8c8a85ba30fdb18c432fdb8d3141a03643aea32d6411203851e04de2d92ca26b" => :sierra
    sha256 "3da2522d9ba6d07d78d4758154aa4cbd11cd8be8202e505939a6d0d54625b7a1" => :el_capitan
    sha256 "e544cbc13b7f95854d8a042bc67efc0d39807d5635a96259739f98b4d567e06c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "glibmm"
  depends_on "gst-plugins-base"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gstreamermm.h>

      int main(int argc, char *argv[]) {
        guint macro, minor, micro;
        Gst::version(macro, minor, micro);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gst_plugins_base.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_lib}/gstreamer-1.0/include
      -I#{include}/gstreamermm-1.0
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gstreamermm-1.0/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gst_plugins_base.opt_lib}
      -L#{gstreamer.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgstapp-1.0
      -lgstaudio-1.0
      -lgstbase-1.0
      -lgstcheck-1.0
      -lgstcontroller-1.0
      -lgstfft-1.0
      -lgstnet-1.0
      -lgstpbutils-1.0
      -lgstreamer-1.0
      -lgstreamermm-1.0
      -lgstriff-1.0
      -lgstrtp-1.0
      -lgstsdp-1.0
      -lgsttag-1.0
      -lgstvideo-1.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
