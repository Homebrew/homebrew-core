class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.0.5.tar.bz2"
    sha256 "51aea9e6a3b17f5209d49283a2dee8b9a7cd7ea96028316909da9f0bfe931f09"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.0.5.tar.bz2"
      sha256 "9f0251922886934f2aa32739b5a30eadfefa7c70dd7b3e78f94aa6fc54e0c55b"
    end
  end

  bottle do
    sha256 arm64_big_sur: "262e96f1222fb5ceba5b195ab5742913cdf75ac6fd8e5923e563f37301e137c5"
    sha256 big_sur:       "d5b25fb05e6fe57692a0b6669f84723ca6867c8c9bd2fdcbcbfd816a5d2b907f"
    sha256 catalina:      "39222ff0b21fb409570d2dbaea7e53a99b87d8a54a9e7e59b28b15b26a35f790"
    sha256 mojave:        "31c07493cfb5225d8f09ba6728de4a0516abf2b9d8b357cbabb2c09c4d1b902c"
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
  depends_on "qt@5"
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
