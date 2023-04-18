class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.3.tar.bz2"
    sha256 "27584dc845c7e70db8c9267990945f17322a1ecc80ff8b452e9ca916a0ce9091"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.3.tar.bz2"
      sha256 "662ef6c8c4bd70d0f35fd1c5f08b91549b9436638b65f8a1a33956b09df89fc6"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e4929eefb82d8314c37c828c9984bf93bc466794037428ea00ef1d3628a39789"
    sha256 arm64_monterey: "cd47f0af9709cefb718e215c78246db9bc5373bd1bab8c3c3ecec6d57b527eb4"
    sha256 arm64_big_sur:  "7831956e30eed00b872abb7fa2d2cd601cf5cf9b95c64ab6778adbb37b7fa879"
    sha256 ventura:        "6fe668042ac57eb2be0354f6d1d25030178c515d52adaa6ea099ad5af9d4fa66"
    sha256 monterey:       "0cf73a457021285efbb1e280a37bba970a88b194b8c3b9102f168e7773812d28"
    sha256 big_sur:        "5eeb05a9095f43865dcf5edb43f0f195fb3b6883ba7946286df9380db1d0a857"
    sha256 x86_64_linux:   "de76769390b18483bcd56119fe63b53f696b6121115f891193f06468465e1125"
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
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libmodplug"
  depends_on "libnotify"
  depends_on "libopenmpt"
  depends_on "libsamplerate"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    args = %w[
      -Dgtk=false
      -Dqt6=true
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
