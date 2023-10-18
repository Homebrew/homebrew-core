class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.4.tar.gz"
  sha256 "1529ef5bc3b9ef3adc2a7964505912f7305103e269e50cc0316f500b22053ac9"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a80c924499b6343ada666c6d93d0f3ad947d61919bace2219bc3bff05618f0a6"
    sha256 cellar: :any,                 arm64_ventura:  "3ac1d1b35699efd38f3d43b3f2da6e4a411aca4fc5d30f045b76c5d72803f128"
    sha256 cellar: :any,                 arm64_monterey: "7347ccc2946b6f196d992e3a70ff91be2e20e5774f8ebca43a342975d73fbe1e"
    sha256 cellar: :any,                 sonoma:         "782f61271704cec16479e82873e9cafc209d9fd03974cc3772585e5fd6333757"
    sha256 cellar: :any,                 ventura:        "4f08beba8c524daabee69fbf7d66491d3fda03e950da7edbad833ee1035b4d6d"
    sha256 cellar: :any,                 monterey:       "c8b6db1f82fbe79764c7317890b06cdfa722b126bf40f5849b089c8bb5f53949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff062bfebf16739b60acbb1a6300841fc8657a0ccf26f51ebca5bb93af6542c"
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
