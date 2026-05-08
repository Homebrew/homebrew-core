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
    rebuild 3
    sha256 arm64_tahoe:   "ffdfc68f4754dbaa320a933bc7be5962b1c01d80502419b0186826c270aeafbb"
    sha256 arm64_sequoia: "cc3f88588abc2ae5f77b94d48c906d4f054d395deff705b674c67a779f2143f1"
    sha256 arm64_sonoma:  "98dd0b14fd0830c27791b7b20258a8fba82fc94eeb0477d853b871df636f6c67"
    sha256 sonoma:        "273c80c6e3c195716502702bbbf8db483f28543d81953d367d719cf5fc1ddfc8"
    sha256 arm64_linux:   "c0baaca63ec22d339a797b4be872cdd047cdcc0e0316c311ee841a5fa6bad978"
    sha256 x86_64_linux:  "b97e762b2657955a9f6c8494cb29d6b2dfba66c0b70bbaea88eaaa4d45a29011"
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
  depends_on "sdl3"
  depends_on "wavpack"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxml2"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  # Remove `libsidplayfp`, which is actually Windows only dependency, remove in next release
  patch do
    url "https://github.com/audacious-media-player/audacious/commit/61fae600af7e71c5dc03c74f45dee6edc4889611.patch?full_index=1"
    sha256 "b5e6fa094fa5db30b1154e30a6372d89006803f4f4069b0f219d8d086007a05d"
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
