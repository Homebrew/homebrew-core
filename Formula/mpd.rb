class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.21/mpd-0.21.23.tar.xz"
  sha256 "439f522ca9800f375e4fb459ec31e61b3d824fc5c0580ff06dac48b5d21207a3"
  head "https://github.com/MusicPlayerDaemon/MPD.git"

  bottle do
    cellar :any
    sha256 "a23fab9584321aeb90354c9f221a31e17a912a198cb9ec6437c87ede8120de6d" => :catalina
    sha256 "31c5f6acf2e7fcec454bc0a52cee053836d178a40e3d6fa1d16809a687556988" => :mojave
    sha256 "299e9cf5b5ea05c35c18f570f3c2134c6c5f1f8f01660b07c8aca47765fb17e8" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
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
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libsamplerate"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "sqlite"

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = std_meson_args + %W[
      --sysconfdir=#{etc}
      -Dlibwrap=disabled
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dupnp=enabled
      -Dvorbisenc=enabled
    ]

    system "meson", *args, "output/release", "."
    system "ninja", "-C", "output/release"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "ninja", "-C", "output/release", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats
    <<~EOS
      MPD requires a config file to start.
      Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
        - ~/.mpd/mpd.conf
        - ~/.mpdconf
      and tailor it to your needs.
    EOS
  end

  plist_options :manual => "mpd"

  def plist
    <<~EOS
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
    port = free_port

    (testpath/"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    pid = fork do
      exec "#{bin}/mpd --stdout --no-daemon #{testpath}/mpd.conf"
    end
    sleep 2

    begin
      ohai "Connect to MPD command (localhost:#{port})"
      TCPSocket.open("localhost", port) do |sock|
        assert_match "OK MPD", sock.gets
        ohai "Ping server"
        sock.puts("ping")
        assert_match "OK", sock.gets
        sock.close
      end
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
