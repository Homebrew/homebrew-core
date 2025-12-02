class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.28.1.tar.xz"
  sha256 "84cf6145f9cc82bfff690005be24392c8f3c52f8e00ff04d8eea371429c09424"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "acf90be6429afc82b654e0ae3a9ce93fb59ccfaa1defff2818ee8bf7d4ec8c4b"
    sha256 arm64_sequoia: "08c3174445bc5f78a9c46cfdf4d73b59a1c75978f6a6a203076a418b77241f77"
    sha256 arm64_sonoma:  "e49c3a736f6e9ecda80831e0939fe3f9249f3f99299ac5533e13e9cd871163a5"
    sha256 arm64_ventura: "1ba80183f196e5a7270c7aeb0278eded8f11e0a06c3c1379f10bb2b78e7aa05b"
    sha256 sonoma:        "babf88521d92e177519e9abe1f72252550a91be1d5656e64d290d7edfeb1480b"
    sha256 ventura:       "fca929565aa586300f59d5e377dd9ff43abe337c7ccf4b99d0a9af55ef1fd1a3"
    sha256 arm64_linux:   "1d26d6975b267b3bc016364b0747e1ed58df5945795759d40683c3d8f27d3eec"
    sha256 x86_64_linux:  "f1adfecfef5d86dccaf1ccce34f6cc8fa0748c440422c697986f6ff53e966717"
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
