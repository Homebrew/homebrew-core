class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.0.0/gucharmap-15.0.0.tar.bz2"
  sha256 "c85c1554923df5028de1247bbba782e61ba15f2d21a711a68b23cd3a35788c97"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "94b8a8d68d2e41fc967141191571c92033341eb253e26924ad2254a5fbebeea6"
    sha256 arm64_big_sur:  "f8c13179e94a42e165fbc997b764d5490715dc578052471abd34b745564522bf"
    sha256 monterey:       "965e8db0910c3fbb535c598c759f0bcf6ece18465ec72aea1507e7c15f66d249"
    sha256 big_sur:        "86d98d0143f5ce0369bc8a5dfc9d28ba698e58ec594bd2889cafd9872c221b00"
    sha256 catalina:       "3764303688c44734939493f7d9f8f4260a5cac8b6a56586730516a0b8b2b3aca"
    sha256 x86_64_linux:   "8eb21b303b018769b8cb24e4bc8d292e0f1b5ed81dbbff4f06ee66afb13d2a9c"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  resource "ucd" do
    url "https://www.unicode.org/Public/15.0.0/ucd/UCD.zip"
    sha256 "5fbde400f3e687d25cc9b0a8d30d7619e76cb2f4c3e85ba9df8ec1312cb6718c"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "24b154691fc97cb44267b925d62064297086b3f896b57a8181c7b6d42702a026"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
