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
    sha256 arm64_big_sur: "cf18a780331e9c43a8ed6ecd26424ebbdffd601d70d02ce785cb33e808833d6d"
    sha256 big_sur:       "ec0cff191b694dc9b41d1a4e79d954609d1504a60041be12690c5819f4ece9e2"
    sha256 catalina:      "726a9eb19a6dd938d6869810b22cfcd8a0645a42978c5fc1aeba4bb5f9c42ba1"
    sha256 mojave:        "120bad55e3a9649ec92a78f847ff0cbfcc2d46508c40dd5a93b314adef809cb0"
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
