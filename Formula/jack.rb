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
    rebuild 2
    sha256 arm64_monterey: "2741e332d2f3c3bf82d78e724cc33f029c20e60f2f3aef9a22255f7ceb356951"
    sha256 arm64_big_sur:  "8460ec59472c5dc1d7f1196dcb68578539054cfb597390793f91c99eb0b9596a"
    sha256 monterey:       "51cb7f7e929c43eaa1f6db9fac1ff1b6acec8ca074eb83b276f1ac70bfdf3f7e"
    sha256 big_sur:        "939c93be6d821e73abe360c69c57b0786086b03bcf95233a0ef1836e18c472f7"
    sha256 catalina:       "fbec3032a541f3e9ce3b327994d4bd305f3f849d1cb3831ec460b2bd2e029c08"
    sha256 mojave:         "b2974079582c370b9056ac2f98308cb321dc767ac3f67229e891e1de6bc86c8f"
    sha256 x86_64_linux:   "2a209c4eaf03a6bb1ca47b15acb8f18cbe3fe4d395859f83e31df688bec0b891"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.9"].opt_bin/"python3", "./waf", "install"

    # Remove Python script used to control D-Bus JACK as it isn't enabled in formula
    rm bin/"jack_control"
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
