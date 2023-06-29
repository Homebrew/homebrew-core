class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.3.tar.gz"
  sha256 "321f7d3f72206b2522f30a1cb8ad1936fd4533ffc4d29dd335b1953c9fb371e6"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da5bf065ed02260f06956649b2ee93754bacda5087f19fd8c853ee7066a216a3"
    sha256 cellar: :any,                 arm64_monterey: "e0b2996b64eccc958d3b763b74c252cb1c98fc3226b0e4e23bd6f8782b276664"
    sha256 cellar: :any,                 arm64_big_sur:  "3adf010702a3ab2b4ef6cd6f60bd9441ebd30234ba82f56cbdd06e6ec70d4155"
    sha256 cellar: :any,                 ventura:        "5fd006e36431322f5f5c76537f1d9e53ffb34c555e8807d30c8ebe05ad0d95cd"
    sha256 cellar: :any,                 monterey:       "4e26125a6fcd8a3addcb426f23ac01224a0ec8a8032af4261ba1899eb295d584"
    sha256 cellar: :any,                 big_sur:        "133fe112c2b05d607c3a2e52ccdf6d3c475447500c0e8dc227f635ddd3ffc9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7a4080df73f1c0322dcd44d6d6feece9f99b878258673390972e86ce6465a8"
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
