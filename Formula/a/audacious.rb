class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.5.1.tar.bz2"
    sha256 "7194743a0a41b1d8f582c071488b77f7b917be47ca5e142dd76af5d81d36f9cd"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.5.1.tar.bz2"
      sha256 "f4feedc32776acfa9d24701d3b794fc97822f76da6991e91e627e70e561fdd3b"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "43dddbdc3339e46dd9f16ed25f934a8e3b7840275e34d012ab400d51214afc72"
    sha256 arm64_sequoia: "6152a1ffc0685fe363561de8be7a1d0e48ff715b4ff84280572ae73f5d0fcdf7"
    sha256 arm64_sonoma:  "4d50ad67057b8518b2afe81968b8b439a041807439a38282dede9405fc1e945f"
    sha256 sonoma:        "aa642b6fb11f90296a049298ac3671e7adc0ca1d8f80f3fe57637abf4732c4ea"
    sha256 arm64_linux:   "277e4522ad10fdac7ad7930b41b423a7ac5e895334b9b916c75c96d7bcf60967"
    sha256 x86_64_linux:  "d29b3426f41034f8d0a4874777953e56911d5261d21fa2f83d32b2da3bc722a8"
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
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
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
  depends_on "libsidplayfp"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qtbase"
  depends_on "qtimageformats" => :no_linkage # for webp album covers
  depends_on "qtmultimedia"
  depends_on "qtsvg" => :no_linkage # for svg icons
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxml2"
    depends_on "pulseaudio"
  end

  def install
    odie "plugins resource needs to be updated" if build.stable? && version != resource("plugins").version

    args = %w[
      -Dgtk=false
    ]

    system "meson", "setup", "build", "-Ddbus=false", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("plugins").stage do
      args += %w[
        -Dmpris2=false
        -Dmac-media-keys=true
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS,
      and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
