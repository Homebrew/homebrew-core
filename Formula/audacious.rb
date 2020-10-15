class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.0.5.tar.bz2"
    sha256 "51aea9e6a3b17f5209d49283a2dee8b9a7cd7ea96028316909da9f0bfe931f09"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.0.5.tar.bz2"
      sha256 "9f0251922886934f2aa32739b5a30eadfefa7c70dd7b3e78f94aa6fc54e0c55b"
    end
  end

  bottle do
    sha256 "b91911a8c81456b650fb88eb7f9dda4844538632b034a783eb209524aa6a2467" => :catalina
    sha256 "09a4731e3df8b48e43305051a64ca73b07fec7ff76cf1cee1edc734a3cac99ea" => :mojave
    sha256 "49a8da44d9aabfeb8d45057d7f04270a6cc0efc65f703d1e810edf74437691af" => :high_sierra
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
