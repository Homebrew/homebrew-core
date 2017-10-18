class LibicalGlib < Formula
  desc "Wrapper of libical with support of GObject Introspection"
  homepage "https://wiki.gnome.org/Projects/libical-glib"
  url "https://download.gnome.org/sources/libical-glib/1.0/libical-glib-1.0.4.tar.xz"
  sha256 "3e47c7c19a403e77a598cfa8fc82c8e9ea0b3625e2f28bdcec096aeba37fb0cd"
  revision 1

  bottle do
    sha256 "f0276d45417caf684ffe27f510f0b5004aeadd48b774d1590a6be597160470e3" => :high_sierra
    sha256 "69ac0d22224466d8fd02e65fafe758da6b3d06724accbea82d8b2dcad81f659a" => :sierra
    sha256 "8e4a96b46dc44aa61f0247b4d5d7afdd6c55bd457b693e599c4da5d74e8e8f49" => :el_capitan
    sha256 "485062bfe30e8dc477adaf4e25d1a2d91c53f8be33993901a078bec1ae09b4ef" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libical"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libical-glib/libical-glib.h>

      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libical = Formula["libical"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{libical.opt_include}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libical.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lical
      -lical-glib-1.0
      -licalss
      -licalvcal
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
