class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.1.tar.gz"
  sha256 "d734e4cf488be763cf123e5976f3154f0094815093eecdf71e0e9ae148431883"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "394ec658cd38eb410d47d8cf69b2ba5e3676e85abffda9f56430f50030909db8"
    sha256 cellar: :any,                 arm64_monterey: "dbab6a34b765066e0be8a77b90b1bd5157bac31665302566405d338ae609b03f"
    sha256 cellar: :any,                 arm64_big_sur:  "273bf2db324797f0f909f388cf5dc5d7f717b0ab45f218872035c0c16d520d3f"
    sha256 cellar: :any,                 ventura:        "4f6535561288d26f7bda0d8825d7ee8354a9e7a088900dad968e961b9cfc7e4e"
    sha256 cellar: :any,                 monterey:       "9936295c244a7cb84dea9142647ea05ae560fa29afb920f790a2df468ea06a72"
    sha256 cellar: :any,                 big_sur:        "f12e58b856e8e0872f653baafb3a836d79c82a10d7bb0425a7a0009bfe8264f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7882b6ed850926a1074dc9c31ea7d0e7721221290c1ecec82bc5fe0d09246038"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "systemd"
  end

  resource "homebrew-test" do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-Denable-alsa=#{OS.linux?}",
                    "-Denable-aufile=ON",
                    "-Denable-coverage=OFF",
                    "-Denable-coreaudio=#{OS.mac?}",
                    "-Denable-coremidi=#{OS.mac?}",
                    "-Denable-dart=OFF",
                    "-Denable-dbus=OFF",
                    "-Denable-dsound=OFF",
                    "-Denable-floats=OFF",
                    "-Denable-fpe-check=OFF",
                    "-Denable-framework=OFF",
                    "-Denable-ipv6=ON",
                    "-Denable-jack=#{OS.linux?}",
                    "-Denable-ladspa=OFF",
                    "-Denable-lash=OFF",
                    "-Denable-libinstpatch=OFF",
                    "-Denable-libsndfile=ON",
                    "-Denable-midishare=OFF",
                    "-Denable-network=ON",
                    "-Denable-opensles=OFF",
                    "-Denable-oboe=OFF",
                    "-Denable-openmp=OFF",
                    "-Denable-oss=OFF",
                    "-Denable-pipewire=OFF",
                    "-Denable-portaudio=ON",
                    "-Denable-profiling=OFF",
                    "-Denable-pulseaudio=OFF",
                    "-Denable-readline=ON",
                    "-Denable-sdl2=OFF",
                    "-Denable-systemd=#{OS.linux?}",
                    "-Denable-trap-on-fpe=OFF",
                    "-Denable-threads=ON",
                    "-Denable-ubsan=OFF",
                    "-Denable-wasapi=OFF",
                    "-Denable-waveout=OFF",
                    "-Denable-winmidi=OFF",
                    *std_cmake_args

    # On macOS, readline is keg-only so use the absolute path to its pc file
    # uses_from_macos "readline" produces another error
    # Related error: Package 'readline', required by 'fluidsynth', not found
    if OS.mac?
      inreplace "build/fluidsynth.pc",
                "readline",
                "#{Formula["readline"].opt_lib}/pkgconfig/readline.pc"
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
    assert_predicate wavout, :exist?

    # Check the pkg-config module
    system "pkg-config", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
