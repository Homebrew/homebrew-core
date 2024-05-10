class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.0.tar.xz"
  sha256 "243a0736b978a33dee29f9cca7521733b78a65b5418206fef7bd1c3d4cf10b64"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "06c6aaadeca8f79c27867c56b8bb90fa9a7d00f84862cee7c837b611ffb8dbbc"
    sha256 cellar: :any, arm64_ventura:  "e71518b5feb9f2c6a91152948fb8bb0492d7677581d9cd22f72e1a53e89753bb"
    sha256 cellar: :any, arm64_monterey: "b4912ed29c6ef6796ae80480b8a806afeb55366d73661c5fe778500ada73ea7c"
    sha256 cellar: :any, sonoma:         "18232de7a1880477f40f421262fa05f92278c7f494b3cabb1848dda92c545010"
    sha256 cellar: :any, ventura:        "53fa7ded83d0f45fd7c8c25fedb970f1084bc4861f10988f36c2f2cfd6064552"
    sha256 cellar: :any, monterey:       "a0368a0df2890afe6e66d1c45c55af4b2cd7eb8bdaf2b3e173fd711a2aad6fb6"
    sha256               x86_64_linux:   "35cd3a9f81432449e9b0f457a20c8e94e0d2c804da0210a5deffe9e0b8549b4f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "lzo"
  depends_on "pixman"

  uses_from_macos "zlib"

  def install
    args = %w[
      -Dfontconfig=enabled
      -Dfreetype=enabled
      -Dpng=enabled
      -Dglib=enabled
      -Dxcb=enabled
      -Dxlib=enabled
      -Dzlib=enabled
      -Dglib=enabled
    ]
    args << "-Dquartz=enabled" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
