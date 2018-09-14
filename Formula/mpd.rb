class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.20/mpd-0.20.21.tar.xz"
  sha256 "8322764dc265c20f05c8c8fdfdd578b0722e74626bef56fcd8eebfb01acc58dc"
  revision 1

  bottle do
    sha256 "e8745fde74d53001ceab4881a52b8484d2251e9bd695a7ca0b49fd2fdd1fcdf0" => :mojave
    sha256 "da4ed86f57b7cf8dfafb0eda2292761adfb1a472c519b45574667bcecc3cb277" => :high_sierra
    sha256 "dea4dd579189abb931a01a9d499e07d283a07d452c27f71ba0c43d151b901d2d" => :sierra
    sha256 "aff57f03edaf545460b4474be279f4a0c7062a11ead05f8ee7a985e3b49fb59d" => :el_capitan
  end

  head do
    url "https://github.com/MusicPlayerDaemon/MPD.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "lame"
  depends_on "libao"
  depends_on "libid3tag"
  depends_on "libmpdclient"
  depends_on "libsamplerate"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "sqlite"

  needs :cxx11

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-libwrap
      --disable-mad
      --disable-mpc
      --disable-soundcloud
      --enable-ao
      --enable-bzip2
      --enable-expat
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
      --enable-upnp
      --enable-vorbis-encoder
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "make", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats; <<~EOS
    MPD requires a config file to start.
    Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
      - ~/.mpd/mpd.conf
      - ~/.mpdconf
    and tailor it to your needs.
  EOS
  end

  plist_options :manual => "mpd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpd</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProcessType</key>
        <string>Interactive</string>
    </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{bin}/mpd --stdout --no-daemon --no-config"
    end
    sleep 2

    begin
      assert_match "OK MPD", shell_output("curl localhost:6600")
      assert_match "ACK", shell_output("(sleep 2; echo playid foo) | nc localhost 6600")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
