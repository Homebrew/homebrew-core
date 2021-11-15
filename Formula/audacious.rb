class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.1.tar.bz2"
    sha256 "1f58858f9789e867c513b5272987f13bdfb09332b03c2814ad4c6e29f525e35c"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.1.tar.bz2"
      sha256 "dad6fc625055349d589e36e8e5c8ae7dfafcddfe96894806509696d82bb61d4c"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "c8cf37b67448119b2fdef16c9eaf1b924a433f645037f9fd8a8f37fef46832a7"
    sha256 big_sur:       "e2a1c27f807d9df77b5572cecf17e03bb59e344468f7cd017c6b427812072d5d"
    sha256 catalina:      "032de1da579c13edd37c77bb3b57e8189b290a8c7235523a9cb4ca9fe8c51636"
    sha256 mojave:        "121c7484b3210d173fc5704adad85c1238b097c475ffdb78a56af6e25dbe3c8b"
    sha256 x86_64_linux:  "77d5c5d671b6a28d855747fda5fe1d76b3ed81084f81f740ceabbeaa6e8a8959"
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
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
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "wavpack"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_meson_args + %w[
      -Ddbus=false
      -Dgtk=false
      -Dqt=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    resource("plugins").stage do
      args += %w[
        -Dcoreaudio=false
        -Dmpris2=false
        -Dmac-media-keys=true
        -Dcpp_std=c++14
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      mkdir "build" do
        system "meson", *args, ".."
        system "ninja", "-v"
        system "ninja", "install", "-v"
      end
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      Core Audio output has been disabled as it does not work (fails to set audio unit input property).
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS, and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
