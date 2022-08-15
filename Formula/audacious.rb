class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 1

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
    sha256 arm64_monterey: "c35e7535ae9705ac9d9a7e28b760081d86c1abdae99c5e722e0cdb7ed5707987"
    sha256 arm64_big_sur:  "aff5aaeab24180aff1ae91da6421edf7d58d81af57c1f5c6a049db247316fbd2"
    sha256 monterey:       "7893f401cc6bc9e7a4f8d22cf18b551ef3ea152711887f3c6037b55f446e351b"
    sha256 big_sur:        "22a2be0cacb4ae5d259e494bd08cb59cb5b38e28e2de8b492ae7d27bd676b12c"
    sha256 catalina:       "853a11fdf1db841cb70cd9af5ef80109356ef398cea6b44a39119bae18f31815"
    sha256 x86_64_linux:   "2fc678cf70ed5f060c0dc24be179a95f314b3a859491f5403b74fe3462744d7f"
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

  on_linux do
    depends_on "gcc"
  end

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
