class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.3.1.tar.bz2"
    sha256 "85e9e26841505b51e342ee72a2d05f19bef894f567a029ebb3f3e0c1adb42042"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.3.1.tar.bz2"
      sha256 "2dea26e3af583a2d684df240b27b2b2932bcd653df4db500a85f4fe5d5fdc8a6"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f99bf1f66a85cbf56c241631359565a7dc7b430867fff248accd24cf45d0b9e1"
    sha256 arm64_ventura:  "25f3142a4ca788ca2b4d57853ac8d98c4ee1d8229b728462af226323720339b8"
    sha256 arm64_monterey: "1f5a9d58989dbcdf06ae5732091ee93ebc6b29398d8cea949cf30dd7c90ddae3"
    sha256 arm64_big_sur:  "c1e294e3fbe48409e07f1b924003f764bb70943ff1added3bb4d0dafe75b113d"
    sha256 sonoma:         "0aaddbba68b5065355183a2ab14fe2fcd47ba4f043d3c17bdd64cc8adccce1e7"
    sha256 ventura:        "0f3c9cacff3ff240a13e88f08055f3a3bfc0cfda6ba46200286f355f5f421fca"
    sha256 monterey:       "23828385f46ff08c4149b36923b564d6a2696e74ebc48d86a4ddbd3da5b1639e"
    sha256 big_sur:        "ab1f11e873c42f1f75645724dffaa80c828c6d26532383c5c69fc96f13036a8c"
    sha256 x86_64_linux:   "d51a93f3d472cf7bd0814dda1f99ab25b4bbdf7fd01c886150aadbeda1b3dad7"
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
