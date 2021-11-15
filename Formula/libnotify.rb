class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz"
  sha256 "66c0517ed16df7af258e83208faaf5069727dfd66995c4bbc51c16954d674761"
  license "LGPL-2.1-or-later"

  # libnotify uses GNOME's "even-numbered minor is stable" version scheme but
  # we've been using a development version 0.7.x for many years, so we have to
  # match development versions until we're on a stable release.
  livecheck do
    url :stable
    regex(/libnotify-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "050ec9423bfe7bfaef51c4f173692d55758a9e52a6df70dff96a667e3ed4bc75"
    sha256 cellar: :any, arm64_big_sur:  "49e795c1869eb3f544ef5710861ec3ef0f829f6b8db64b3c44722025e2c4ba97"
    sha256 cellar: :any, monterey:       "6c4586e332260bdf0db438be5ec2194d9831aaef30a53ce661352bb05f361ee4"
    sha256 cellar: :any, big_sur:        "415ef3754d6910255fc161e352b0b5a7006efe3aa5684fbf8abeb98514358562"
    sha256 cellar: :any, catalina:       "367a8d51cb565452392b9bc92c753ca641c23f91fc4ff93fb6166b63f2beafda"
    sha256 cellar: :any, mojave:         "e6d5a6a87f885bf421e6a70c9cef1c6aaf89db46a98216af6c06754246a8f896"
    sha256 cellar: :any, high_sierra:    "0560e601843a3e42a4823904dd5534212efd823292444a9588f1cf99ea8bc8f5"
    sha256               x86_64_linux:   "3be2be401ff1fda07663fdeaf8929ca12b92fa136acfedc2a273b1abcd9438bd"
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
