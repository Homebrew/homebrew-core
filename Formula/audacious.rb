class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "http://audacious-media-player.org"
  
  stable do
    url "http://distfiles.audacious-media-player.org/audacious-3.8.2.tar.bz2"
    sha256 "bdf1471cce9becf9599c742c03bdf67a2b26d9101f7d865f900a74d57addbe93"

    resource "plugins" do
      url "http://distfiles.audacious-media-player.org/audacious-plugins-3.8.2.tar.bz2"
      sha256 "d7cefca7a0e32bf4e58bb6e84df157268b5e9a6771a0e8c2da98b03f92a5fdd4"
    end
  end
  
  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build

  depends_on "neon"
  depends_on "glib"
  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "faad2" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "flac" => :recommended
  depends_on "fluid-synth" => :recommended
  depends_on "lame" => :recommended
  depends_on "libbs2b" => :recommended
  depends_on "libcue" => :recommended
  depends_on "libnotify" => :recommended
  depends_on "libsamplerate" => :recommended
  depends_on "libsoxr" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "mpg123" => :recommended
  depends_on "qt" => :recommended
  depends_on "sdl2" => :recommended
  depends_on "wavpack" => :recommended

  depends_on "gtk+" => :optional
  depends_on "jack" => :optional
  depends_on "libmms" => :optional
  depends_on "libmodplug" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-coreaudio
      --enable-mac-media-keys
      --disable-mpris2
    ]

    args << "--enable-qt" if build.with? "qt"
    args << "--disable-gtk" if build.without? "gtk+"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("plugins").stage do
      ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./autogen.sh" if build.head?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    audtool does not work due to a broken dbus implementation on macOS, so is not built
    coreaudio output has been disabled as it does not work (Fails to set audio unit input property.)
    GTK+ gui is not built by default as the QT gui has better integration with macOS, and when built, the gtk gui takes precedence
    EOS
  end

  test do
    system bin/"audacious", "-H", "-V", "-q", "-E", test_fixtures("test.wav"), "-p"
  end
end
