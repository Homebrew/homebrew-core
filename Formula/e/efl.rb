class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.28.1.tar.xz"
  sha256 "84cf6145f9cc82bfff690005be24392c8f3c52f8e00ff04d8eea371429c09424"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 1

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4f7931f7bbba7b77cdffec8ad7f786fbf391c751cca06e21bfd36db76b45a9c8"
    sha256 arm64_sequoia: "ca39300711b68d4b9b204e11a26e087d653d07b820a566abb8f2571511bef9df"
    sha256 arm64_sonoma:  "37008b1b96a2bcb02b6f107554e48064f18f45b749db0f59fe58f9b08dc801a2"
    sha256 sonoma:        "b34db0280911ff0635abc86cc72887bdf894f0a308e1ec23b69afbe9b12db2c4"
    sha256 arm64_linux:   "29ab5ac199b353fc6d3e2ee896f36e804f5745111c73e2e31405c7cec5f2a874"
    sha256 x86_64_linux:  "5345f7a0bfe8001c148667d79ab69e5488f7619213a4dba32de5ae23cf239659"
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
