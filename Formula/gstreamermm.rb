class Gstreamermm < Formula
  desc "GStreamer C++ bindings"
  homepage "https://gstreamer.freedesktop.org/bindings/cplusplus.html"
  url "https://download.gnome.org/sources/gstreamermm/1.10/gstreamermm-1.10.0.tar.xz"
  sha256 "be58fe9ef7d7e392568ec85e80a84f4730adbf91fb0355ff7d7c616675ea8d60"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ccfdabeca639a0c10260c232dc8f4a24af5fc7b4b8c9e5befee65be29314dbb1"
    sha256 cellar: :any, big_sur:       "2b46f0bc113d6125e1823d24365a8c4c664576de16db5ad3ce2e2a0157b1f99a"
    sha256 cellar: :any, catalina:      "f65023da1c10400540a04a1bb422f42342406d013e89a1344a04778283824eb8"
    sha256 cellar: :any, mojave:        "d5cbb27b618ded15a4b8dd132195307927a03358a88575e4934d7b0da0148e75"
  end

  disable! date: "2021-03-18", because: "is unmaintained upstream and does not build with glib 2.68.0+"

  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

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
    glibmm = Formula["glibmm@2.66"]
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    libsigcxx = Formula["libsigc++@2"]
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
      -lsigc-2.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
