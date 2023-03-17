class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.1.tar.gz"
  sha256 "d734e4cf488be763cf123e5976f3154f0094815093eecdf71e0e9ae148431883"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a26af41a80f6ebc0eba1d1384711e6c6d8d33afb6b8067eb8f8823f2ac822c56"
    sha256 cellar: :any,                 arm64_monterey: "818475a9c43ce1d0455058537351af0715c60c569107ba526cd9be52544ae5ec"
    sha256 cellar: :any,                 arm64_big_sur:  "71794f63885755d5df4bc4923763ddceae628c9814c0f4c205b0fd1994a3a902"
    sha256 cellar: :any,                 ventura:        "51e6bf112fffec4af8a6c11f67693c14205a4133062c9ae67e5c1b19d10bfc8a"
    sha256 cellar: :any,                 monterey:       "780ae5444afd386bd2558cd75d52633002eacdbed8d4397d24af01d822f6d7ed"
    sha256 cellar: :any,                 big_sur:        "811ee977e81f6ce4fd6a6c9a7564e3d3045afe69b699a3be7bb6944ee36f188e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1ecdd216ed9b722a92ae4ba6ce3274e2d3b4ad12b9688abb4b1fc56294994c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
  end
end
