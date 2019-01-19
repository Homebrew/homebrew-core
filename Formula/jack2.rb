class Jack2 < Formula
  desc "Audio Connection Kit"
  homepage "http://jackaudio.org"
  url "https://github.com/jackaudio/jack2/releases/download/v1.9.12/jack2-1.9.12.tar.gz"
  sha256 "deefe2f936dc32f59ad3cef7e37276c2035ef8a024ca92118f35c9a292272e33"
  head "https://github.com/jackaudio/jack2.git"

  depends_on "aften"

  conflicts_with "jack", :because => "both install `jackd` binaries and libraries"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  plist_options :manual => "jackd -X coremidi -d coreaudio"

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
    begin
      source_name = "test_source"
      sink_name = "test_sink"
      jackd_cmd = "#{bin}/jackd -X coremidi -d dummy"
      midi_source_cmd = "#{bin}/jack_midiseq #{source_name} 16000 0 60 8000"
      midi_sink_cmd = "#{bin}/jack_midi_dump #{sink_name}"
      midi_connect_cmd = "#{bin}/jack_connect #{source_name}:out #{sink_name}:input"
      ohai jackd_cmd
      jackd = IO.popen jackd_cmd
      system "#{bin}/jack_wait", "--wait", "--timeout", "10"
      ohai midi_source_cmd
      midi_source = IO.popen midi_source_cmd
      ohai midi_sink_cmd
      midi_sink = IO.popen midi_sink_cmd
      sleep 1
      system midi_connect_cmd
      sleep 1
      Process.kill "TERM", midi_sink.pid
      midi_dump = midi_sink.read
      assert_match "90 3c 40", midi_dump
      assert_match "80 3c 40", midi_dump
    ensure
      ohai "killing jackd"
      Process.kill "TERM", midi_sink.pid
      Process.kill "TERM", midi_source.pid
      Process.kill "TERM", jackd.pid
      Process.wait
    end
  end
end
