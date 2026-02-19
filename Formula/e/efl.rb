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
    rebuild 1
    sha256 arm64_tahoe:   "0aedecfbc82dd64256f03aab33fa8ae335417d303f1ae5232312c7db3d83f807"
    sha256 arm64_sequoia: "20d779a469c064dd9c5f0026d92088fd471072ff8892a198b4a4541e18be5ade"
    sha256 arm64_sonoma:  "6f12d404e850445aa6f2e4022a661eda4125799f98e00ca8a33a6084c16f97b4"
    sha256 sonoma:        "68674b9cc25d8d8553903bda991c6a27d96ee0c64cff9495385a7c43e6d4351a"
    sha256 arm64_linux:   "5c03f04940d543eab7aa8229188ba8854693ad479b969da545c8fcb2f0ee305e"
    sha256 x86_64_linux:  "9bbb7e3a1d35545a60a72cbe6f5c67ae49ae7e1bde124659822926cebb92284c"
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

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
