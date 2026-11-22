class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "c51ebe04c8a445f4a7dd5a86e09a27b5c5af547756574edc52fc61c88ebe8427"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    manifest_sha256 "5a1ee9350f9aafbf24424d99913f771f7021738b24bfeb184521bda5d697d574"
    sha256 cellar: :any, arm64_golden_gate: "fffd61d6aec99aa4d00ac5a475415e13512fa27a9efb0d01ea9a93c290555f8e"
    sha256 cellar: :any, arm64_tahoe:       "d4ff666dd6b168e18a95032496132ee580a75e1562c66ae8bf4dd8d979f0a806"
    sha256 cellar: :any, arm64_sequoia:     "36ffa276ed0cd98616a949530aae5c49ab6cf79a26757ee60fcfdad16bea26cd"
    sha256 cellar: :any, arm64_linux:       "54e354f6737dbbb809d56da7e36c8e2a3c3e7f0c3e3a74d0155d6543988e5c95"
    sha256 cellar: :any, x86_64_linux:      "680bf92e6157ba086528d974e1ed7427f35c07bb42b6f26f49ed52f23705b94d"
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
    ENV.append_path "PKG_CONFIG_PATH", formula_opt_lib("systemd")/"pkgconfig" if OS.linux?
    ENV.append_path "PKG_CONFIG_PATH", formula_opt_lib("readline")/"pkgconfig" if OS.mac?
    system "pkgconf", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
