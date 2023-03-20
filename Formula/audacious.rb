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
    sha256 arm64_ventura:  "d0dedeae2538b361776268675cd15b6d31bb447baf5292f0a6553bb0a2d0b0fd"
    sha256 arm64_monterey: "0bce7dffa93cc7ed89b1a498916964ec77b2d2d60d91f3fd37f260590c35ffe9"
    sha256 arm64_big_sur:  "aaaae3e21e0006eb92147032b2a2e7352cec6e1a218fdbef64850fece604a162"
    sha256 ventura:        "3e42f001f3b6b8f5d534bdbee468fbd65487b2326eef311e309ecfcfb207411e"
    sha256 monterey:       "c71da6067a089b7e74c847fdc31d2c58f49adf7e7287d31521ea73aa7f648885"
    sha256 big_sur:        "dce962afa17a17605baaed5931780aed01a7fb4f40831e178684c61ac3a8566b"
    sha256 x86_64_linux:   "daac98ed40d90ec2e11f305e706417b998c5211f4291e6542ad7baac464fcfe3"
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
