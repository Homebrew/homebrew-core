class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.19.tar.gz"
  sha256 "9030f4dc11773351b6ac96affd9c89803a5587ebc1b091e5ff866f433327e4b0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ffbab9c78a68d9500801476cc963340ed638795d9d31cf0f20162380216f03b2"
    sha256 big_sur:       "5fdfbe4b083a1fb96c2a6d66d8a32bff2eda70dd5488b5cd3f75c088f4e2c158"
    sha256 catalina:      "03952b355f2868cafb1dc5b726ae9910602ae06454ed8f757402cb6c7b540dda"
    sha256 mojave:        "bb3a77a180f342d3eafc91705996d7346331cbdc36efbb41022433a7dd2084c7"
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

  service do
    run [opt_bin/"jackd", "-X", "coremidi", "-d", "coreaudio"]
    keep_alive true
    working_dir opt_prefix
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin"
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
