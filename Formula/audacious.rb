class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 2

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
    sha256 arm64_monterey: "0b7a74c191a1867d442e0c370516010a7fb7757530942408538b83367cc65a93"
    sha256 arm64_big_sur:  "819afa4489c4f26017ce6966291d3b82b859ceb96476edf963973d4b75c010a8"
    sha256 monterey:       "0415bc32ce00ab3c6413496c1a8c3748a44d4a23c6ba27d0d62991b0c4a96c9a"
    sha256 big_sur:        "8b29082bd4c5dd088db4d990b1c965f80022037e7b8f4cd5abcf0fbd111211fe"
    sha256 catalina:       "7f7bea293e9f75013b2dd6dbf376644578a35165f2cb7e84a2c2634971a3bf9c"
    sha256 x86_64_linux:   "a5883bc3e84402141c2e0effac40850fd8ca91f71ef33ac3f4140741e1349f1e"
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
  depends_on "ffmpeg@4"
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
