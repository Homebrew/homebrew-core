class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.26.2.tar.xz"
  sha256 "2979cfbc728a1a1f72ad86c2467d861ed91e664d3f17ef03190fb5c5f405301c"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4e5419af6ae133d283eb21a6d21323539fe476e82954166c234c39731d3b3211"
    sha256 arm64_big_sur:  "208c7fed52c78fbd218e187bd5e0a7c25b71797ef9360be6ce6587ee97b8b335"
    sha256 monterey:       "e5e9a7cd7ea454590be9b04e8c3738fb06f9938af8baee744ce54ba4214a20a9"
    sha256 big_sur:        "dcb683ba7af8b8ab4e273535ec53b67149bc598210546d8c828bfd8dc2690d1b"
    sha256 catalina:       "0761cc1408d03ad98c8fc57b7c4d6e15ca3e69687396fcecbcb4fcea7563e790"
    sha256 x86_64_linux:   "a9935da9d1ca8a269eb2de4d2552f8e72aa4a5537f1c7ab13de2760049367ddb"
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
