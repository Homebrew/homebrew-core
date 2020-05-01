class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"

  bottle do
    cellar :any
    sha256 "1f88c8df8a310b7b51f71f299b845239e713f8d80bcc65ef092cfb0ffcd827df" => :catalina
    sha256 "7f8af3c459f54e9ccbe6cadcdddcc949786639eef6ea186f476bc64ea5d50ff7" => :mojave
    sha256 "eafb8a7c6fcc581ba8fc2f00a45940f0af3b7d28f2f856d961918951a3b9b346" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version "python3"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpygobject-override-dir=#{lib}/python#{pyver}/site-packages", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
