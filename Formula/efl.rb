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

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bullet"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  def install
    args = [
      "--prefix=#{prefix}",
      "-Davahi=false",
      "-Dx11=false",
      "-Dcocoa=false", # default
      "-Deeze=false",
      "-Dopengl=none",
      "-Deina-magic-debug=false",
      "-Dbuild-examples=false",
      "-Dbuild-tests=false",
      "-Dglib=true", # default
      "-Dg-mainloop=false", # default (requires glib)
      "-Dsystemd=false",
      "-Dxinput2=true", # default (requires x11)
      "-Dxinput22=true", # default (requires x11)
      "-Dharfbuzz=true", # default
      "-Dedje-sound-and-video=false",
      "-Dembedded-lz4=true",
      "-Dlibmount=false",
      "-Dv4l2=false",
      "-Delua=true", # default
      "-Dnls=true", # default
    ]

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
