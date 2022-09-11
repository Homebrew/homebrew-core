class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_monterey: "e73d7d2ba1908611f61a85f17abe510321743ca824007765d0cb4c6ec9a6bf30"
    sha256 cellar: :any, arm64_big_sur:  "ac5b11b07edb669242f21ccb6101e2799221d1b27835b162332669ee0a2e485e"
    sha256 cellar: :any, monterey:       "87d77af0920b14f4e1d0971559eb317237b2d09b3d2fc35819bbc0bcb474f3f7"
    sha256 cellar: :any, big_sur:        "59e6101c892e9c91e17867e3f8d638be067b4b19e0160acc16126cc2a6dd32cc"
    sha256 cellar: :any, catalina:       "fcdaca6fc63c78e7cef569c0ea13f72df16c31cfc8f04f3e3a04e8f64e578fe5"
    sha256               x86_64_linux:   "4294c303be4c1644f12200a4760e57585a0d6186d4e42031b9d7e6e376f771e4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "sqlite"

  def install
    site_packages = prefix/Language::Python.site_packages("python3.10")

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpygobject-override-dir=#{site_packages}", ".."
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
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
