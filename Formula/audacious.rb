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

  bottle do
    sha256 arm64_big_sur: "0a7a6d08b3f5e431152195e85cd073742885fa2866ee78da5d75d936cc90bc23"
    sha256 big_sur:       "c439d889df3e04bea1eb6260a07a62fa837549ecb27fd5a00cf984768ea7f231"
    sha256 catalina:      "d91c25c904352bb6e316f455ebf81b3141fc2e33658f57d6447e92def99ac805"
    sha256 mojave:        "5fb824614d82b9e9b158c86a445d91a970a04fd82348335d773128c66ae3b9f0"
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
