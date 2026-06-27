class Gtkglext < Formula
  desc "OpenGL extension to GTK+"
  homepage "https://gitlab.gnome.org/Archive/gtkglext"
  url "https://download.gnome.org/sources/gtkglext/1.2/gtkglext-1.2.0.tar.gz"
  sha256 "e5073f3c6b816e7fa67d359d9745a5bb5de94a628ac85f624c992925a46844f9"
  license "LGPL-2.1-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "764e97c887571389641f45ef171ca06af71ac4bc5fcaaff56e85c9d663cad92a"
    sha256 cellar: :any,                 arm64_sequoia:  "c7d1eb4cd50853e471d11db5256550eb6eea8d0b66424e66bf4662f54bbcfc64"
    sha256 cellar: :any,                 arm64_sonoma:   "dbda7d73cfcf8ff56426e761be3d928b47cc25142be9e436f29634f306ceb02d"
    sha256 cellar: :any,                 arm64_ventura:  "97c561405376a0e3f03d661edb63332c449464eca670d94d95276d7a16708ada"
    sha256 cellar: :any,                 arm64_monterey: "4082e12c1b01e56342b49fb16241fb6e4e52b6c1f5691052b332f75b8892781f"
    sha256 cellar: :any,                 sonoma:         "ea372181dc03023ea581b14ca996646f6da8cdb54d81911f5b999281c70ecdd7"
    sha256 cellar: :any,                 ventura:        "986da9680b6032a4f4ae363e3c18176dce0bd276367e311c36b09494198d79d1"
    sha256 cellar: :any,                 monterey:       "6f045d38e2a584449fa6b5fc275f13b46bce7a4bd892219bb9dbe9bae44a9835"
    sha256                               arm64_linux:    "8111b6fa90b879f9572ff71ebec5ff279bc5b4532c19f52331286f39783c04ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea86597c739ebbf55d551970dee174085bfc3d0c4d70f06f0cce969979ef2af"
  end

  deprecate! date: "2026-03-14", because: :repo_archived
  disable! date: "2027-03-14", because: :repo_archived

  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"

    resource "pangox-compat" do
      url "https://gitlab.gnome.org/Archive/pangox-compat/-/archive/0.0.2/pangox-compat-0.0.2.tar.gz"
      sha256 "c8076b3d54d5088974dbb088a9d991686d7340f368beebaf437b78dfed6c5cd5"

      # Taken from https://aur.archlinux.org/cgit/aur.git/plain/0002-disable-shaper.patch?h=pangox-compat.
      patch :DATA
    end
  end

  # All these MacPorts patches have already been included upstream. A new release
  # of gtkglext for gtk+2.0 remains uncertain though.
  patch :p0 do
    file "Patches/gtkglext/patch-configure.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-examples-pixmap-mixed.c.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-examples-pixmap.c.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gdk-gdkglglext.h.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gdk-gdkglquery.c.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gdk-gdkglshapes.c.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gdk-makefile.in.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gtk-gtkglwidget.c.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-gtk-makefile.in.diff"
  end

  patch :p0 do
    file "Patches/gtkglext/patch-makefile.in.diff"
  end

  patch :p0 do
    url "https://trac.macports.org/raw-attachment/ticket/56260/patch-index-gdkglshapes-osx.diff"
    sha256 "699ddd676b12a6c087e3b0a7064cc9ef391eac3d84c531b661948bf1699ebcc5"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    unless OS.mac?
      resource("pangox-compat").stage do
        system "./autogen.sh"
        system "./configure", "--prefix=#{libexec}"
        system "make"
        system "make", "install"
      end
      ENV.append_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

      system "autoreconf", "--force", "--install", "--verbose"
    end

    args = []
    if OS.mac?
      args << "--without-x"
      # Fix flat_namespace usage
      inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress",
                "${wl}-undefined ${wl}dynamic_lookup"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtkgl.h>

      int main(int argc, char *argv[]) {
        int version_check = GTKGLEXT_CHECK_VERSION(1, 2, 0);
        return 0;
      }
    C

    ENV.append_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gtkglext-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
--- pangox-compat/pangox.c.orig 2020-05-04 18:31:53.421197064 -0400
+++ pangox-compat/pangox.c      2020-05-04 18:32:41.251146923 -0400
@@ -277,11 +277,11 @@ pango_x_font_class_init (PangoXFontClass
   object_class->finalize = pango_x_font_finalize;
   object_class->dispose = pango_x_font_dispose;

   font_class->describe = pango_x_font_describe;
   font_class->get_coverage = pango_x_font_get_coverage;
-  font_class->find_shaper = pango_x_font_find_shaper;
+  /* font_class->find_shaper = pango_x_font_find_shaper; */
   font_class->get_glyph_extents = pango_x_font_get_glyph_extents;
   font_class->get_metrics = pango_x_font_get_metrics;
   font_class->get_font_map = pango_x_font_get_font_map;
 }
