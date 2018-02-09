class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.20/mpd-0.20.16.tar.xz"
  sha256 "29e1676288e61a8bee6b687d23ba6ca42ccec4dc87c6a0e81d119aea27dcd06a"

  bottle do
    sha256 "8b9c8751e80ee5f1b8a5b71a1a5af808163077094c44ecdaaaf779c3579201b0" => :high_sierra
    sha256 "36fa67718907b451377f4c671ccee6ece6b4e3b1c0d46387f981adc20f78c41c" => :sierra
    sha256 "d163d22acdc03ddf07659bd17f742115ac16ece4a7635c2aee5cdc781e67364f" => :el_capitan
  end

  head do
    url "https://github.com/MusicPlayerDaemon/MPD.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-wavpack", "Build with wavpack support (for .wv files)"
  option "with-lastfm", "Build with last-fm support (for experimental Last.fm radio)"
  option "with-lame", "Build with lame support (for MP3 encoding when streaming)"
  option "with-two-lame", "Build with two-lame support (for MP2 encoding when streaming)"
  option "with-flac", "Build with flac support (for Flac encoding when streaming)"
  option "with-libvorbis", "Build with vorbis support (for Ogg encoding)"
  option "with-yajl", "Build with yajl support (for playing from soundcloud)"
  option "with-opus", "Build with opus support (for Opus encoding and decoding)"
  option "with-libmodplug", "Build with modplug support (for decoding modules supported by MODPlug)"
  option "with-pulseaudio", "Build with PulseAudio support (for sending audio output to a PulseAudio sound server)"
  option "with-upnp", "Build with upnp database plugin support"

  deprecated_option "with-vorbis" => "with-libvorbis"

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "sqlite"
  depends_on "libsamplerate"
  depends_on "icu4c"

  needs :cxx11

  depends_on "libmpdclient"
  depends_on "ffmpeg" # lots of codecs
  # mpd also supports mad, mpg123, libsndfile, and audiofile, but those are
  # redundant with ffmpeg
  depends_on "fluid-synth"              # MIDI
  depends_on "faad2"                    # MP4/AAC
  depends_on "wavpack" => :optional     # WavPack
  depends_on "libshout" => :optional    # Streaming (also pulls in Vorbis encoding)
  depends_on "lame" => :optional        # MP3 encoding
  depends_on "two-lame" => :optional    # MP2 encoding
  depends_on "flac" => :optional        # Flac encoding
  depends_on "jack" => :optional        # Output to JACK
  depends_on "libmms" => :optional      # MMS input
  depends_on "libzzip" => :optional     # Reading from within ZIPs
  depends_on "yajl" => :optional        # JSON library for SoundCloud
  depends_on "opus" => :optional        # Opus support
  depends_on "libvorbis" => :optional
  depends_on "libnfs" => :optional
  depends_on "mad" => :optional
  depends_on "libmodplug" => :optional  # MODPlug decoder
  depends_on "pulseaudio" => :optional
  depends_on "libao" => :optional       # Output to libao
  if build.with? "upnp"
    depends_on "expat"
    depends_on "libupnp"
  end

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
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
      --disable-libwrap
    ]

    args << "--disable-mad" if build.without? "mad"
    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.with? "lastfm"
    args << "--disable-lame-encoder" if build.without? "lame"
    args << "--disable-soundcloud" if build.without? "yajl"
    args << "--enable-vorbis-encoder" if build.with? "libvorbis"
    args << "--enable-nfs" if build.with? "libnfs"
    args << "--enable-modplug" if build.with? "libmodplug"
    args << "--enable-pulse" if build.with? "pulseaudio"
    args << "--enable-ao" if build.with? "libao"
    if build.with? "upnp"
      args << "--enable-upnp"
      args << "--enable-expat"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "make", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
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
