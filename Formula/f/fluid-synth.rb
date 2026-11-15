class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "ca376b42a3c1b186a4c8c248931789a455ac94a89b777394969d678010c2f91f"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9871338bbc7783df3e35ab21d8e603f2014fbe39663505cecd848ed468cf5943"
    sha256 cellar: :any, arm64_tahoe:       "1e683e477113018fb2f8a32a673bcd4da049a220e5bd9cb945af5a5237274007"
    sha256 cellar: :any, arm64_sequoia:     "f1c723969ebcdbd9b7cfc93679d2f934801d3283f980cc02390b79d1d6ae19b6"
    sha256 cellar: :any, arm64_linux:       "c1967274c765144a1f5d4ae2a3e2dda797b18e1bea1cab95022a573c57d1a74e"
    sha256 cellar: :any, x86_64_linux:      "a1dd2bbf5c60c895a4f5f22f350967c848528efb29f2a1c60282421f18b31ae2"
  end

  depends_on "cmake" => :build
  depends_on "gcem" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libsndfile"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  resource "homebrew-test", :test do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -Denable-alsa=#{OS.linux?}
      -Denable-aufile=ON
      -Denable-coverage=OFF
      -Denable-coreaudio=#{OS.mac?}
      -Denable-coremidi=#{OS.mac?}
      -Denable-dbus=OFF
      -Denable-dsound=OFF
      -Denable-floats=OFF
      -Denable-fpe-check=OFF
      -Denable-framework=OFF
      -Denable-ipv6=ON
      -Denable-jack=#{OS.linux?}
      -Denable-ladspa=OFF
      -Denable-libsndfile=ON
      -Denable-midishare=OFF
      -Denable-network=ON
      -Denable-opensles=OFF
      -Denable-oboe=OFF
      -Denable-openmp=OFF
      -Denable-oss=OFF
      -Denable-pipewire=#{OS.linux?}
      -Denable-portaudio=#{OS.mac?}
      -Denable-profiling=OFF
      -Denable-pulseaudio=#{OS.linux?}
      -Denable-readline=ON
      -Denable-sdl3=OFF
      -Denable-systemd=#{OS.linux?}
      -Denable-trap-on-fpe=OFF
      -Denable-threads=ON
      -Denable-ubsan=OFF
      -Denable-wasapi=OFF
      -Denable-waveout=OFF
      -Denable-winmidi=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # On macOS, readline is keg-only so use the absolute path to its pc file
    # uses_from_macos "readline" produces another error
    # Related error: Package 'readline', required by 'fluidsynth', not found
    if OS.mac?
      inreplace "build/fluidsynth.pc",
                "readline",
                "#{formula_opt_lib("readline")}/pkgconfig/readline.pc"
    end

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "sf2"
  end

  test do
    # Synthesize wav file from example midi
    resource("homebrew-test").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_path_exists wavout

    # Check the pkg-config module
    ENV.append_path "PKG_CONFIG_PATH", Formula["systemd"].lib/"pkgconfig" if OS.linux?
    system "pkgconf", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
