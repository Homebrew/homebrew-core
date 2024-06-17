class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.58/librsvg-2.58.1.tar.xz"
  sha256 "3728596290a8576d305d06ec8afdf473516feee9dff22e03235eac433d56824e"
  license "LGPL-2.1-or-later"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "624c307c3a8fa7449de9ae9e8d7400cf3a0d2a1a7a018e7e246a7dd96d5743fc"
    sha256                               arm64_ventura:  "89dce53b61aee6de7f1d23e04cf3e4a49c93ddc293e4af61954636f0cb82ea2c"
    sha256                               arm64_monterey: "97b9f353e42b106ef78a0df58370ba72f4937907a64c50b80215b9f85c8f2406"
    sha256                               sonoma:         "77a813c682bfa9a23354510c89e327c41e58c9d7ee1fc58769927a1cb97f5e8b"
    sha256                               ventura:        "2350745eca6a4b73982e9e8c40f4924f5eff08bb43380f4dda54e2586fa19a71"
    sha256                               monterey:       "5dc7f34da42fb6afb423cc1e6808f6091801fb5739cd19896aabaec6c493d267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbbf0196a8e175c7cad2d6a398f83afbf5dc109aa8362b5b90ce73e8f68467e7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libpng"
  end

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
