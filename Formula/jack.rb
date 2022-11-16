class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.21.tar.gz"
  sha256 "8b044a40ba5393b47605a920ba30744fdf8bf77d210eca90d39c8637fe6bc65d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "9cf54ddb51aba0829825dcec602d85e18b232eac4c8557efe7a7e5bdcca05608"
    sha256 arm64_monterey: "5b8c6629a97e463b96bb2672c3a0cfb8da8b5cf91d147f632c7f6d351a7fe3cb"
    sha256 arm64_big_sur:  "a9732675aef73bf6a133a8130b46a81a275aad83abfc0d0d72b91f34580d11fb"
    sha256 ventura:        "4153adcbb219bfafaaf25aed11df7268222e255201f75b1ae16b1a59e6b54da7"
    sha256 monterey:       "8047fbdd9eefa085dd3e66584d907bbbcfee2e7651f80836ff621844d39a53aa"
    sha256 big_sur:        "f1f19dbf7ba59e389e51d325997b6c4173ebcf3c076732edd1d3ebbf51af5ab0"
    sha256 catalina:       "d4ac8617761bb59dfaa1390d237ef7ad2b2733283353a8484fd4a1c8a82b4f79"
    sha256 x86_64_linux:   "8a52eb2b5ec3ad62d4b573e7dd5997142d7435600da01cae8156dd6f6b0dae9b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "readline"

  on_macos do
    depends_on "aften"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    if OS.mac? && MacOS.version <= :high_sierra
      # See https://github.com/jackaudio/jack2/issues/640#issuecomment-723022578
      ENV.append "LDFLAGS", "-Wl,-compatibility_version,1"
      ENV.append "LDFLAGS", "-Wl,-current_version,#{version}"
    end
    python3 = "python3.10"
    system python3, "./waf", "configure", "--prefix=#{prefix}", "--example-tools"
    system python3, "./waf", "build"
    system python3, "./waf", "install"
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
      if OS.mac?
        exec "#{bin}/jackd", "-X", "coremidi", "-d", "dummy"
      else
        exec "#{bin}/jackd", "-d", "dummy"
      end
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
