class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.1.tar.xz"
  sha256 "d033e6d4d6ccbf46a436c31628a4b661b36dca1f5d4174fe0173e274f4e62557"
  license "LGPL-2.1-or-later"

  # libnotify uses GNOME's "even-numbered minor is stable" version scheme but
  # we've been using a development version 0.7.x for many years, so we have to
  # match development versions until we're on a stable release.
  livecheck do
    url :stable
    regex(/libnotify-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "35c78598bf57327589324de7d7b768fdfe4749cb0ace7726420ed9c3363e70dd"
    sha256 cellar: :any, arm64_monterey: "e74a881d6b7bab835785508958289242fb39098e807bad857c29e98c9bf25616"
    sha256 cellar: :any, arm64_big_sur:  "430b006a29d0db68781f2b3cc36699f98b6589b4760732fe51cbce8876fccaa3"
    sha256 cellar: :any, ventura:        "448296b13d9a5e5f6a3c19098f3c871bbecb02a7eda8e0abf38deced258e879a"
    sha256 cellar: :any, monterey:       "ded8ffdb381fd27fa6407c444f80511d174d51fef350b0cd94eb95acbf1cbc72"
    sha256 cellar: :any, big_sur:        "7b91ad58427f7fd234d867f831001083d7c8dd93e1e1a9b87b947890dd478a85"
    sha256 cellar: :any, catalina:       "48063c7f852ad9cd72d927e8749055b01c7c86c75ecd5b7bf7323418df359a94"
    sha256               x86_64_linux:   "5dfeef9cc3d400f64182826d287b76c8c6f4969e51293e75914c34711a918561"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dtests=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libnotify/notify.h>

      int main(int argc, char *argv[]) {
        g_assert_true(notify_init("testapp"));
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{lib}
      -lnotify
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
