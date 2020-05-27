class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.24.1.tar.xz"
  sha256 "67aafb53926426b245ba934e3a4adc2f465041b9c3cbcabfff8f914367f94bf7"

  bottle do
    sha256 "c2f72151d626413c35edeb310b522919c9575028b1d4d5a8912cf5ba39c15655" => :catalina
    sha256 "6a6768c0e0ed5344023c4bd8a6ace46b4a90cf24634226a286d59f2c44455c64" => :mojave
    sha256 "535b32a46830c401d6513fc816e67758f52f1f99b90bb27ed8bcc745d256a446" => :high_sierra
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
  depends_on "luajit"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  uses_from_macos "zlib"

  def install
    args = std_meson_args + %w[
      -Davahi=false
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dcocoa=true
      -Dembedded-lz4=false
      -Deeze=false
      -Dglib=true
      -Dlibmount=false
      -Dopengl=full
      -Dphysics=true
      -Dsystemd=false
      -Dv4l2=false
      -Dx11=false
    ]

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
