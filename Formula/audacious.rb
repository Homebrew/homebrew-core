class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 2

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.2.tar.bz2"
    sha256 "feb304e470a481fe2b3c4ca1c9cb3b23ec262540c12d0d1e6c22a5eb625e04b3"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.2.tar.bz2"
      sha256 "6fa0f69c3a1041eb877c37109513ab4a2a0a56a77d9e8c13a1581cf1439a417f"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a3015cefc23d7e52def1896203de76922c652b8234ddc2cf0c4e4a90bace04d7"
    sha256 arm64_big_sur:  "325d25c7d0998253960ad4344e5dbd0055806de247163d79724a0392dc5c3730"
    sha256 monterey:       "4d85ec6a6ee927388bf4f1d3956116901798ca30f1a63a85c674df5037097ee9"
    sha256 big_sur:        "3016b1ce25b2055357f52138030166773ec5445cf45c87032d7771133c352886"
    sha256 catalina:       "0ab3edc5ffe3f71c8f7c453bdd929939264b4e4f51373909da3720111b96466d"
    sha256 x86_64_linux:   "a9b7551315f0fab21041da8c8d6f864573ed83c9db54f01bc0b099cadac87583"
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
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    args = std_meson_args + %w[
      -Dgtk=false
      -Dqt=true
    ]

    mkdir "build" do
      system "meson", *args, "-Ddbus=false", ".."
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
