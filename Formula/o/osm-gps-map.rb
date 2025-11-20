class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    # TODO: Make autoconf, automake, gtk-doc and libtool HEAD-only on next release
    url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.0/osm-gps-map-1.2.0.tar.gz"
    sha256 "ddec11449f37b5dffb4bca134d024623897c6140af1f9981a8acc512dbf6a7a5"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Apply Void Linux's patch for libsoup 3. Remove in the next release.
    # This is a rebased copy of upstream commit that applies on stable release
    # https://github.com/nzjrs/osm-gps-map/commit/a7965751821d5bb55f8fb37b4045295d0c44dd9b
    patch do
      url "https://raw.githubusercontent.com/void-linux/void-packages/f6b0cf8ca04678301773327b9a2d5efb043dae3d/srcpkgs/libosmgpsmap/patches/libsoup-3.patch"
      sha256 "045c8c9a6a317aea89158154818399815525f5b5cb0340332f92b250d73e5bc6"
    end

    # Backport fix for add_point
    patch do
      url "https://github.com/nzjrs/osm-gps-map/commit/639ea5e02d2cb47cbc15554d61b1ba6b0ee073b6.patch?full_index=1"
      sha256 "7979e6d050e83b2e0f84c3e9671828c59de36d491b497a1b780b62bcc9ea1f69"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "e749fe56b5482a3a9418de1bba012a642a932b92fb092d669056f932a4a0f615"
    sha256                               arm64_sequoia: "1f92caba8e52495b92a2ed81e6e7f6959d25bb7ac12353872df3638d6ecbe7f1"
    sha256                               arm64_sonoma:  "12026a32374a2a8797d650c925fdc5ad9c19833c1019003d542e507e0fe80448"
    sha256                               arm64_ventura: "e7a42cd9f4293f91416301dfd756ce762dda325b466c511c4e9cfbeacc996e97"
    sha256                               sonoma:        "fd61181265716039211a690890598b64359740fc017868051062c23044641343"
    sha256                               ventura:       "6ab0a704cd25d754617aa95f97fcc8ea447def786f33771a3352c31a1fbc657f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a000a5d4c6bc3b19b78e93ca25463f187a59a3f5ecd9187650955164ef7f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1025b0a42d58429dfad4828bef5b3041e12a1bf54a8a849b3fc302f998a1c5d"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git", branch: "master"
    depends_on "autoconf-archive" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    # TODO: Remove next release
    system "autoreconf", "--force", "--install", "--verbose" if build.stable?

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", "--enable-introspection", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs osmgpsmap-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags

    # (test:40601): Gtk-WARNING **: 23:06:24.466: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
