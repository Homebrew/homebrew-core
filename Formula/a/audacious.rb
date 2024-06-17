class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.4.tar.bz2"
    sha256 "aadc5d26ea2954236a00153e424094d9e6eb55c5c324c08fd0491b7c2ae2f830"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.4.tar.bz2"
      sha256 "3caf3a5fe5b6f2808f461f85132fbff4ae22a53ef9f3d26d9e6030f6c6d5baa2"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e03058224d658019e61fbbc1c04a385e26e470ec902c6cdeb7d033b72614bf73"
    sha256 arm64_ventura:  "f1cff5889746668db16352051f62bff287fd0c29f343de04f2d06d61851ef72c"
    sha256 arm64_monterey: "79546d5bd47b5f3a5c44f73f89ff223301139f213e519c553ca76c564ee795c7"
    sha256 sonoma:         "873a17be51d0898e05fa87a46b781822a0a22d31480e0bb25cb5bc18bed11279"
    sha256 ventura:        "cd34f079dc5b8268ac03b5762ea1716b7a4ebc1145b4f1e64f22894111f68d66"
    sha256 monterey:       "b1056a92f3c10f9d818e27d60e54f4ce9b0f42812a18a76510555b596a499986"
    sha256 x86_64_linux:   "695f2ae08a9e8b2e3e34358b64eaa566d39121334abf57c913323ccbeb9e5483"
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git", branch: "master"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git", branch: "master"
    end
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libmodplug"
  depends_on "libnotify"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxml2"
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

  def install
    odie "plugins resource needs to be updated" if build.stable? && version != resource("plugins").version

    args = %w[
      -Dgtk=false
    ]

    system "meson", "setup", "build", *std_meson_args, *args, "-Ddbus=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("plugins").stage do
      args += %w[
        -Dmpris2=false
        -Dmac-media-keys=true
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "meson", "setup", "build", *std_meson_args, *args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS, and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
