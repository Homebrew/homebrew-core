class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

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
    sha256 arm64_ventura:  "54de674d0590c05be8d17fddbe15175919e137de43b65ce70aded7173a4df72f"
    sha256 arm64_monterey: "a3015cefc23d7e52def1896203de76922c652b8234ddc2cf0c4e4a90bace04d7"
    sha256 arm64_big_sur:  "325d25c7d0998253960ad4344e5dbd0055806de247163d79724a0392dc5c3730"
    sha256 ventura:        "946f75f5419edb4d49193cc616c5d0a9b3d1e59813ad273c3b592cb96c7b63ec"
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
