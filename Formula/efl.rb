class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.23.3.tar.xz"
  sha256 "53cea69eaabe443a099fb204b7353e968e7bb62b41fbb0da24451403c7a56901"

  bottle do
    sha256 "d04b2c44f519e791014658b0994f49eee9940ca684ea2de402923bea23db4adc" => :mojave
    sha256 "6d222b36c6172b11ad731ca15481c31a46ad38544ffed22d0d0a778861e63e85" => :high_sierra
    sha256 "5e303d498b339b5c248e9167efd68c362013d9198fdf5dbed98138721688a8db" => :sierra
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

  # Fix build with 10.15+ SDK
  patch do
    url "https://github.com/Enlightenment/efl/commit/51e4bcc32c8b3d20980dd4f669e92e32a95a82fb.patch?full_index=1"
    sha256 "173f15e9154f76898ce090211a7c87675d9198a79a32c7ef59df870cfafea02c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
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
