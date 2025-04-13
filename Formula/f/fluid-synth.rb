class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "fc492a255f453e65ac5b99a25e6ffbe0fbd64d6a4fe824bacd68de16fe8af7ba"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14801936f533878e75bd2a7ca822614c42a48e73a831ef18a7806d14a8fd4d94"
    sha256 cellar: :any,                 arm64_sonoma:  "e44e506ec1d4561f54c6e237573f3d82abb4c508f9d454cd40b7feca14f7cced"
    sha256 cellar: :any,                 arm64_ventura: "b4037dee927e2f4bf7e34670de593a523fffd80b6f66c374eae7bec3c232b1bd"
    sha256 cellar: :any,                 sonoma:        "c2a746d5cdab9ff258799fcb9a60033725d396b8232b71adad4121ae5d14595b"
    sha256 cellar: :any,                 ventura:       "ebe9d0fc293d2099a754f966d68578af17afc42a8d48c4c833550525fb18fad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429fc46f1f27851c2de9a9c3b86e02db1de00b9bc5af8a2bd3d210ca6eb5fdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd94acdafb047b17dd15b64f7bf893f411f7db9c37f294bfd6ee19b04374e36c"
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
    ENV.append_path "PKG_CONFIG_PATH", Formula["systemd"].lib/"pkgconfig" if OS.linux?
    system "pkgconf", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
