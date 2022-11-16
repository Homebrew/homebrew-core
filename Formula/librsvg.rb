class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.55/librsvg-2.55.1.tar.xz"
  sha256 "6baf48a9d3a56fd13bbfbb9f1f76759b240b70a1fa220fd238474d66a926f98c"
  license "LGPL-2.1-or-later"

  # We use a common regex because librsvg doesn't use GNOME's "even-numbered
  # minor is stable" version scheme (at least as a "trial" for 2.55.x).
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "ab87ef72c0f3772c7073f34cd88138ae60a9a6d1da7e9200ba4f1596c0715eee"
    sha256                               arm64_monterey: "7677c86c5a390ef740e1ecc43ed9dd5aac71942181d444d09d68420bf140cbb0"
    sha256                               arm64_big_sur:  "94df281def54411823fae7dd450a7befd8f2bfb1d23fd02c3c75379abbf82a4f"
    sha256                               ventura:        "31d0589c5cd74542298c0c95da64e0a8e09d2bd101dd1083d0d5fdf15cceb53a"
    sha256                               monterey:       "a60462f0695f53a813c1c1f68a38a48fcf8d55c94ee80c6992a169bf775b0d26"
    sha256                               big_sur:        "a8d34f5378591f386148ad96a8f6a359a525483383c4894d93791a58460490fc"
    sha256                               catalina:       "491d993ed584eb8c4e2c7e3818ff871b38783fa6ed076233fc93d5546e55f038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93be523ec2aa4953ce6965abbfd46097fb73e1fe224649bcc8ea277da3c97a19"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "pango"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-Bsymbolic
      --enable-tools=yes
      --enable-pixbuf-loader=yes
      --enable-introspection=yes
    ]

    system "./configure", *args

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    inreplace "gdk-pixbuf-loader/Makefile",
              "$(GDK_PIXBUF_QUERYLOADERS) > $(DESTDIR)$(gdk_pixbuf_cache_file) ;",
              ""

    system "make", "install",
      "gdk_pixbuf_binarydir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders",
      "gdk_pixbuf_moduledir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders"
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/librsvg-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lm
      -lrsvg-2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
