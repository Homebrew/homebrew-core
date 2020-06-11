class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.0.4.tar.bz2"
    sha256 "27fae151760cc65193f31224d5ba08fe9f52d2c31b9a688e8a5468b97f7c95bf"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.0.3.tar.bz2"
      sha256 "e2a88f5cac3efe03eedbb8d320ca1bb9300788ce66056d2ceba60eb00f8aef97"
    end
  end

  bottle do
    sha256 "fa6e56b2ca0f53dbf80aaef82fd54334def31cd1cc236ff728ceb8290ae6f2e4" => :catalina
    sha256 "f1e329b3f9af3f5e6e51b0af78bed0722a0b418001cbaf824bec0bbdfcd13243" => :mojave
    sha256 "86c71292a2a4b1d0dff2db82863b01ca3df7beff083256fa9eafebb9b55c24a0" => :high_sierra
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "make" => :build
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
  depends_on :macos # Due to Python 2
  depends_on "mpg123"
  depends_on "neon"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dbus
      --disable-gtk
      --enable-qt
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("plugins").stage do
      args += %w[
        --disable-coreaudio
        --disable-mpris2
        --enable-mac-media-keys
      ]
      inreplace "src/glspectrum/gl-spectrum.cc", "#include <GL/", "#include <"
      inreplace "src/qtglspectrum/gl-spectrum.cc", "#include <GL/", "#include <"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./autogen.sh" if build.head?

      system "./configure", *args
      system "make"
      system "make", "install"
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
