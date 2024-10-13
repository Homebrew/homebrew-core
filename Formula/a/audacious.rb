class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.4.1.tar.bz2"
    sha256 "260d988d168e558f041bbb56692e24c535a96437878d60dfd01efdf6b1226416"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.4.1.tar.bz2"
      sha256 "484ed416b1cf1569ce2cc54208e674b9c516118485b94ce577d7bc5426d05976"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:  "53552087050d5e1c91c16c2d0fc98b7ebe9c8123b20f259245c0531b64de5609"
    sha256 arm64_ventura: "0d943a692b27de31f4f0d2c01525727c9e9fe02865967bb2feec03ee71b3449a"
    sha256 sonoma:        "d32510bb7caedfd26aa795b4e87d539579f19eafe8215acfa859dbef355f50f3"
    sha256 ventura:       "a07ddaf905410b17e0cb40b534bfd18fb8cb2bd325a304fbf5359cda479fefc9"
    sha256 x86_64_linux:  "3c5a0928cf6878761717b747d932b04a62d31924560ae973b0c8983d881cd1fb"
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
