class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.21/mpd-0.21.22.tar.xz"
  sha256 "565687d1899b585350cd66b603e46e5b79affc0a0e36d96d8953c6ccc6f69ba2"
  head "https://github.com/MusicPlayerDaemon/MPD.git"

  bottle do
    cellar :any
    sha256 "4e37cc2a8a089c93180b4d7d86edda3da32143970c092dd81e02aa78f416ef99" => :catalina
    sha256 "fff4a04d43cda607ab73243250c68cf7977f4c67cec7234e3887520544177ed4" => :mojave
    sha256 "a1242b1437c3d7b2400e3bbccf3601fea8c281a24c95c145eba8070d52a45c58" => :high_sierra
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

    args = %W[
      --prefix=#{prefix}
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
