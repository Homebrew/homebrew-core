class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.28.1.tar.xz"
  sha256 "84cf6145f9cc82bfff690005be24392c8f3c52f8e00ff04d8eea371429c09424"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 2

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ff9e74361fb44547be5d3b75bf79da07951908b98ef3d95b36ab1da053eaeae1"
    sha256 arm64_sequoia: "28325e6e21f61357a195f7c59a3f92e30b5a8ad1b0385d2af6521a26a91894f0"
    sha256 arm64_sonoma:  "fef2c199370b4f0bd018d387df3dc1bd118f5b6bcd495a1eb5a821970297ae7f"
    sha256 sonoma:        "911cfa99069ed354357027da43d3db6bf48b0f49c5d3b425eaea82f93c00fea1"
    sha256 arm64_linux:   "36ada6d00f35841ed4c0045fef852362498d5c5c46808bdfcf7b8119d6d5f871"
    sha256 x86_64_linux:  "79eb03fa89429fb5bfe0f6c48388f6964f5088bb45deaed7b9489efb07c1b6ba"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bullet"
  depends_on "cairo"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "lz4"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "mesa"
  end

  # Fix conflicting bool definition.
  patch do
    url "https://git.enlightenment.org/enlightenment/efl/commit/0fcaf460c4a33eb54a51b9d8cb38321603019529.patch"
    sha256 "45492dcea5141814763ed17ac22b068aa74bb165e40afa0fc6cef72af5632335"
  end
  patch do
    url "https://git.enlightenment.org/enlightenment/efl/commit/628c40cce2de0a18818b40615d3351b0c9e9b889.patch"
    sha256 "13823eb598c2dd81c0a3f143a5b043d0163e8d3b843e397ec4666302943b56d9"
  end

  # Remove LuaJIT 2.0 linker args -pagezero_size and -image_base
  # to fix ARM build using LuaJIT 2.1+
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
      -Dlua-interpreter=luajit
    ]
    args << "-Dcocoa=true" if OS.mac?

    # Install in our Cellar - not dbus's
    inreplace "dbus-services/meson.build", "dep.get_pkgconfig_variable('session_bus_services_dir')",
                                           "'#{share}/dbus-1/services'"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
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
