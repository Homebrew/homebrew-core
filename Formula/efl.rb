class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.25.1.tar.xz"
  sha256 "351ca0211ca000234527a503585f039f985607ec9439e34b49d8b8bbf35a7e6b"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 5

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 monterey: "e2bb44a2d447e9c9e5301f806bdc76dc15fe42daf47591ce1de0f45ab358382b"
    sha256 big_sur:  "bbaebb6cf807494d5081a5d524989d9d69f788130883b691463c22b83e8a05f0"
    sha256 catalina: "bcd8fb418d7016654d36ab1640a19aeb6814ae6cd676e4cd15f4efd6eeeca183"
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
