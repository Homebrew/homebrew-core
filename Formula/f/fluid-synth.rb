class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "3d258a3bf97cc20c59eeebfe62c2432fae88adda74d3ad098681c76e0ebf446b"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "094ebbed50819c923aa5844bdf6d54f8d64515bd8230468e48655baa5657ea3c"
    sha256 cellar: :any, arm64_tahoe:       "81b93ae40985f83b1e7842f7e1df4e4cc9fd7ab2d3552dc87950a22a61e22dd2"
    sha256 cellar: :any, arm64_sequoia:     "c7ffeb01347c39ce93345130890348220c3e97b54413dc30f8c525cf98e63acc"
    sha256 cellar: :any, arm64_linux:       "21dffdc0d49a9ba292aa8ba7364c87468bf8ac88061741344012336ae10c2cf6"
    sha256 cellar: :any, x86_64_linux:      "8eb3a652b6ebc7d13951db7256246d9ff5b9005a3b9c3d9c9dfa112437a3b765"
  end

  depends_on "cmake" => :build
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

  def install
    args = %W[
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
    resource "homebrew-test" do
      url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
      sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
    end

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
