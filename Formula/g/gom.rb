class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "1db9a445a9ca871063b486b13569c1d40294fbc61bce2830b92bb464454a88fd"
    sha256 cellar: :any, arm64_monterey: "b0d9c5cdb6be395f3a219b0a507a33083af49b45d67b09f53fd2a1f1854bd974"
    sha256 cellar: :any, arm64_big_sur:  "177ec20f055b4dd60a520964535dda64c7ee7b398b01659b61b9c23044b0ff89"
    sha256 cellar: :any, ventura:        "9e4fbb963c63ea9ce7eb29bcc44b92c0190bd0a4acdb33dce184cf25835ad7a7"
    sha256 cellar: :any, monterey:       "8f54d9de185474a26c57d6252ded258e5964e51e4577409ab9dffa23c11d9f44"
    sha256 cellar: :any, big_sur:        "ecf4e4b467ea8911a19be1f22291ca193e7733490a1dcce5641becc10979a63b"
    sha256               x86_64_linux:   "985855caecd2a4af195101d0bf98fcb14553d83fbd490d40f29112b74d4394e9"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "sqlite"

  def install
    site_packages = prefix/Language::Python.site_packages("python3.11")

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
