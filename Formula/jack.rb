class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.16.tar.gz"
  sha256 "e176d04de94dcaa3f9d32ca1825091e1b938783a78c84e7466abd06af7637d37"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "8700de5add46350491add58d820108aabb5ab18545a4fab4fa20b2f05287e9ef" => :big_sur
    sha256 "0c30bbc478e9305530f69fee884640dee62e5613c997dca8c99e736d8c943899" => :catalina
    sha256 "dc531389d6a167fc2caa078f480272f8048bbf5d85ff4f46c299a42456661360" => :mojave
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

  # Three upstream patches below for ARM compatibility
  patch do
    url "https://github.com/jackaudio/jack2/commit/1a81aa0e.patch?full_index=1"
    sha256 "fec9b9490e9ba9523fa755af8138c0a25b3bbba120dc1c039b8e91c1073ec404"
  end

  patch do
    url "https://github.com/jackaudio/jack2/commit/a92df441.patch?full_index=1"
    sha256 "c1390eaca5d7c762f1f6885de1dba4b30c0f751d47d0e60666e1cf4106dfbd02"
  end

  patch do
    url "https://github.com/jackaudio/jack2/commit/94a59faa.patch?full_index=1"
    sha256 "026d2cdb264b398b8a9828382871aa5447cefb90584ddb534dbf8fc8b364fc6d"
  end

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
    system "#{bin}/jack_connect #{source_name}:out #{sink_name}:input"
    sleep 1
    Process.kill "TERM", midi_sink.pid

    midi_dump = midi_sink.read
    assert_match "90 3c 40", midi_dump
    assert_match "80 3c 40", midi_dump
  end
end
