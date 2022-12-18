class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.26.3.tar.xz"
  sha256 "d9f83aa0fd9334f44deeb4e4952dc0e5144683afac786feebce6030951617d15"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 1

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "64b0e809a08b9f6f4b513008673d37eabd0912253e228d66162f37e1134c063c"
    sha256 arm64_monterey: "da52c5d9b7efa7e3254e2fa4d0648362453794af527548062d8cdb5c459a6f82"
    sha256 arm64_big_sur:  "6c467014094ffefb7488a6033326db7fb42a31f26b20e4e0ad2d8b7071f4c06a"
    sha256 ventura:        "167ae866dd0fcc64300eabddda11141526d0656633c191cb6697cc9c10dcae34"
    sha256 monterey:       "644f71c3c546f95f81a0a0de87fe0a55bf4b1ac0b40f55e3a74ebe5c3248eae9"
    sha256 big_sur:        "f8ebfb27a77a471f78b098ecf404190323f1c590851a9c27cc0da44298a4c0a8"
    sha256 catalina:       "62383e2614ad992aaf6216908e4af05918afb6c87c73fca8af5cc2709d9d8a1c"
    sha256 x86_64_linux:   "7d5e6e19ddadfe16b4403653a7087628979c73df345ace0ff5e83245a18f3b47"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bullet"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"
  depends_on "webp"

  uses_from_macos "zlib"

  # Remove LuaJIT 2.0 linker args -pagezero_size and -image_base
  # to fix ARM build using LuaJIT 2.1+ via `luajit-openresty`
  patch :DATA

  def install
    args = %w[
      -Davahi=false
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dembedded-lz4=false
      -Deeze=false
      -Dglib=true
      -Dinput=false
      -Dlibmount=false
      -Dopengl=full
      -Dphysics=true
      -Dsystemd=false
      -Dv4l2=false
      -Dx11=false
    ]
    args << "-Dcocoa=true" if OS.mac?

    # Install in our Cellar - not dbus's
    inreplace "dbus-services/meson.build", "dep.get_pkgconfig_variable('session_bus_services_dir')",
                                           "'#{share}/dbus-1/services'"

    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end

__END__
diff --git a/meson.build b/meson.build
index a1c5967b82..b10ca832db 100644
--- a/meson.build
+++ b/meson.build
@@ -32,9 +32,6 @@ endif

 #prepare a special linker args flag for binaries on macos
 bin_linker_args = []
-if host_machine.system() == 'darwin'
-  bin_linker_args = ['-pagezero_size', '10000', '-image_base', '100000000']
-endif

 windows = ['windows', 'cygwin']
 #bsd for meson 0.46 and 0.47
