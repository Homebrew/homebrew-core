class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.26.2.tar.xz"
  sha256 "2979cfbc728a1a1f72ad86c2467d861ed91e664d3f17ef03190fb5c5f405301c"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 2

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "233cae91c906c68db5dbf6bc9d64689770bb0e4241fd0591959ac1bc64a190e8"
    sha256 arm64_big_sur:  "e4633c2f3d09f0e81e730782688fcfd495b58c2b4d25c2934b0e8a8b793ee4b8"
    sha256 monterey:       "731d92bb532f54642d90e343fad6610099357861f31eb489233c93ef9a667fef"
    sha256 big_sur:        "fab0a9fc948f6566fff6fd43cef8d71a212fd158c8229f8377844a80e00e248c"
    sha256 catalina:       "eed558c01303be5aecc27009490c197589d55153704c66c30c8b72bc805b2497"
    sha256 x86_64_linux:   "c9730c8a959b14102f2f738b7279e21580111a9070ba3820bf976e03df0f8771"
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit-openresty"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # poppler is built with GCC

  # Remove LuaJIT 2.0 linker args -pagezero_size and -image_base
  # to fix ARM build using LuaJIT 2.1+ via `luajit-openresty`
  patch :DATA

  def install
    args = std_meson_args + %w[
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

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
