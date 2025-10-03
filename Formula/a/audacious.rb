class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

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
    sha256 arm64_tahoe:   "dd28e858bc3a5e82fb73be784b5a2ceec204418dd915406f14b16925dd29fc32"
    sha256 arm64_sequoia: "da5a135943193ca45ebc751814045797ced67045e1329b61f3c8d786a58d150e"
    sha256 arm64_sonoma:  "ec5a613c9c634e0e53fa1a39e52fbdd4d1cd48dcbf9d009ed547cd34b5e26a52"
    sha256 arm64_ventura: "0fc42570974a4671bce5381306c275810c1e032e3eb449a23e36b6d6d67dbc2b"
    sha256 sonoma:        "2f37ac529fefa8d6e1165942699c2371bff51984df7b49daef35aa25cec68172"
    sha256 ventura:       "b06c1d390c4123eb885f785f776dcf1148fb299be937a478a97b9c3d62cb1eb7"
    sha256 x86_64_linux:  "bad3cbe9fb783f5c087d26d1ff4425dc0b72f44f1b5327883e935add9161827c"
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
