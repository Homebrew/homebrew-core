class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.2.tar.xz"
  sha256 "a62b9bb42425e844cc3d6ddde043ff39dbabedd1542eba57a2eb79f85889d45a"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "d74a4f1916b9fe1254268c0b20c50d8a5e8cb101c914450d2c5a34066837a366"
    sha256 cellar: :any, arm64_sonoma:   "8d7d5bc22a123340ce7092b9bf1438ce8e959157e38b784226f48b616a76122a"
    sha256 cellar: :any, arm64_ventura:  "b87ffd7bf969bed012cdce5d639fb12849108a6864afa2d1fd990889856405e4"
    sha256 cellar: :any, arm64_monterey: "3f8d520f1560515c17710512daba768af0ef5b9f7f620cdeec0a619f556b3487"
    sha256 cellar: :any, sonoma:         "e20ab89a1a82b0ec40af53a5b131b46afb94022a3d97d3434710692ae8a90e32"
    sha256 cellar: :any, ventura:        "a7a67c29e5456bd755e5a735fbe75421710b3bd3893da9ed854862f7c5281707"
    sha256 cellar: :any, monterey:       "6069e82da93a9c3d0efe9efee7368674611dcf30c31f7e9e32cd0ab22e99b93d"
    sha256               x86_64_linux:   "8ed937d16eca80e5acbf0b3ae533f933e2d30915abaafb9840026bd9149ed9ba"
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

  on_macos do
    depends_on "gettext"
  end

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
