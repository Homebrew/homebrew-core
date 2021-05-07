class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.18.tar.gz"
  sha256 "5a1d64118034d58529d68a9af42710f9d4843536257c496118065ea3d3e4ae2c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "177463669a498f6d799f00e35e735349683eb04245cc1320bdc174e3bd2c80a2"
    sha256 big_sur:       "b975e32278ec862b2ac8811e347d841c18930529fc47c96fa8861ff3015a04e3"
    sha256 catalina:      "9ebcf7c9b083d2b3a268f743268c7c649c90ed7ab472073fa65814f7a42e67f9"
    sha256 mojave:        "c6ae412a1b0911052894464e87398feca20a1a60a07bebcad5d6053d80781993"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "aften"
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "python@3.9"

  def install
    # See https://github.com/jackaudio/jack2/issues/640#issuecomment-723022578
    ENV.append "LDFLAGS", "-Wl,-compatibility_version,1" if MacOS.version <= :high_sierra
    ENV.append "LDFLAGS", "-Wl,-current_version,#{version}" if MacOS.version <= :high_sierra
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "install"
  end

  plist_options manual: "jackd -X coremidi -d coreaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/jackd</string>
          <string>-X</string>
          <string>coremidi</string>
          <string>-d</string>
          <string>coreaudio</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    source_name = "test_source"
    sink_name = "test_sink"
    fork do
      exec "#{bin}/jackd", "-X", "coremidi", "-d", "dummy"
    end
    system "#{bin}/jack_wait", "--wait", "--timeout", "10"
    fork do
      exec "#{bin}/jack_midiseq", source_name, "16000", "0", "60", "8000"
    end
    midi_sink = IO.popen "#{bin}/jack_midi_dump #{sink_name}"
    sleep 1
    system "#{bin}/jack_connect", "#{source_name}:out", "#{sink_name}:input"
    sleep 1
    Process.kill "TERM", midi_sink.pid

    midi_dump = midi_sink.read
    assert_match "90 3c 40", midi_dump
    assert_match "80 3c 40", midi_dump
  end
end
