class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.2.tar.gz"
  sha256 "cd610810f30566e28fb98c36501f00446a06fa6bae3dc562c8cd3868fe1c0fc7"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9a6c30189ff3e32adcf89ef2607e00082b1de4e4f16cac1dad29e1b93a11416"
    sha256 cellar: :any,                 arm64_monterey: "f2af87ba09c32cce9852640bbfb07a194eacb30b1c7db0e6518ba03aaf13084e"
    sha256 cellar: :any,                 arm64_big_sur:  "05e9126942646fdfa5ba82d81517d8aebd2d9f9a965e6e28421b841d8fb16967"
    sha256 cellar: :any,                 ventura:        "188d4247fcdb947165073731ee24dcc7d0acf04233ed0d7c520d44ef148086eb"
    sha256 cellar: :any,                 monterey:       "13b12b13158bd3627488f5e3c79d22d80f993a15e3b996c669002c1eca79fabf"
    sha256 cellar: :any,                 big_sur:        "8812e4d796ac5647625564a32bfaad8e3648f05a6944fdbdd2c5069625b97361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59e877e5a718dd8a46c948fbe7c788657acf368f0696c66986ea8e58db15da5"
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
