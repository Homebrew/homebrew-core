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
    sha256 arm64_monterey: "4676c483e85f47cc80ac94550a38b7d6396f8be11fb6926c0a1d91d04b644bb7"
    sha256 arm64_big_sur:  "d342eb99eacde6f98e72f02be860833e40c3f73abf83e07bc7a67f1dd6c7ca5a"
    sha256 monterey:       "a47955e6dfaa371506e0fa8c2d630864325253f1fcdc0e24811efc9a9bc5866c"
    sha256 big_sur:        "896bd9223537e4b00cc4a887cc8204c6193973517020d01aabf0f260f4d89f49"
    sha256 catalina:       "04b4249d93ad6ea99475a306f53e7148e5358207ba204886f47ce216ca0a6cf1"
    sha256 x86_64_linux:   "bf92a6849ede5d4e16400d72f001ef1acbf70db63dadaf5b504538f0f1535402"
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
