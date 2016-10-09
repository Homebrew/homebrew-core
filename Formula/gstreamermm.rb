class Gstreamermm < Formula
  desc "GStreamer C++ bindings"
  homepage "https://gstreamer.freedesktop.org/bindings/cplusplus.html"
  url "https://download.gnome.org/sources/gstreamermm/1.8/gstreamermm-1.8.0.tar.xz"
  sha256 "3ee3c1457ea2c32c1e17b784faa828f414ba27a9731532bf26d137a2ad999a44"

  bottle do
    cellar :any
    sha256 "47c358ebd6a0f903cd62ccc9e53a12b8a9235453eb312fb94470718cd5f32927" => :sierra
    sha256 "467de3a6c47ebf36d74be7a1f0f921ad9b67087d8de3213cdbb929c5ec679106" => :el_capitan
    sha256 "96d32cde0a48c4a2a78ed0f9bdcab529eefc82b1c807d87f86f571b252a73dad" => :yosemite
    sha256 "cfb073d82bfdfdd8f485b70021ba0571528e2004bf7a6716ca03f9fd6d5490eb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "glibmm"
  depends_on "gst-plugins-base"

  needs :cxx11

  # Compilation error due to missing header
  # Upstream issue 9 Oct 2016 https://bugzilla.gnome.org/show_bug.cgi?id=772645
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/10887881c9f2859ca90ee8e781f0d10dae02b7a5/gstreamermm/caps.h.patch"
    sha256 "1ec6f9c977c1fc5282c491b5d3867df35e31f00ddf696adf7a9185f47da86627"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
