class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "a92aa83d2ff09a1a6d6186e81d8182bd2958947dffca77a6490ffd41b3ec9dc7"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca0e89ab8223d7a37e6d6f5538eeabe4615f1df94e390032278b2e196f4dc4e6"
    sha256 cellar: :any,                 arm64_sonoma:  "15d461b0410cb395d0ccb051e9db5ea79b0b38e503827203f8f1895432009cec"
    sha256 cellar: :any,                 arm64_ventura: "e08b206eed9b700843df57984420c8636bc8017e1f2cd89f4ad56706cf65b9ee"
    sha256 cellar: :any,                 sonoma:        "a137d7f1f15cf2584df01217bf7749f8ac70d2574c50cee9f3b7d1c3bb1731e1"
    sha256 cellar: :any,                 ventura:       "f53c13346fe1175fe87f557d03545906ebc34d3c6b68a1bbc91661e00a2819c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ec2add2a2da93a50d09b9fe74da36e6f56b01d46b050716e69fa68f47c33b8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
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
    args = %W[
      -Denable-alsa=#{OS.linux?}
      -Denable-aufile=ON
      -Denable-coverage=OFF
      -Denable-coreaudio=#{OS.mac?}
      -Denable-coremidi=#{OS.mac?}
      -Denable-dart=OFF
      -Denable-dbus=OFF
      -Denable-dsound=OFF
      -Denable-floats=OFF
      -Denable-fpe-check=OFF
      -Denable-framework=OFF
      -Denable-ipv6=ON
      -Denable-jack=#{OS.linux?}
      -Denable-ladspa=OFF
      -Denable-lash=OFF
      -Denable-libinstpatch=OFF
      -Denable-libsndfile=ON
      -Denable-midishare=OFF
      -Denable-network=ON
      -Denable-opensles=OFF
      -Denable-oboe=OFF
      -Denable-openmp=OFF
      -Denable-oss=OFF
      -Denable-pipewire=OFF
      -Denable-portaudio=ON
      -Denable-profiling=OFF
      -Denable-pulseaudio=OFF
      -Denable-readline=ON
      -Denable-sdl2=OFF
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
                "#{Formula["readline"].opt_lib}/pkgconfig/readline.pc"
    end

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "sf2"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/src/libfluidsynth.a"
  end

  test do
    # Synthesize wav file from example midi
    resource("homebrew-test").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_path_exists wavout

    # Check the pkg-config module
    system "pkgconf", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
