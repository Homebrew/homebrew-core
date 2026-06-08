class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "72f5720328fe44e2e5c67813885f0a6b4b004d048bd2eeeb0c0064074ebff530"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "611d13e2a55b197803b0450464e8217e62dc4744aa351559a36f6e8c183b897e"
    sha256 cellar: :any,                 arm64_sequoia: "fe2f133e71a92a549b177b80ebc3ed78c7b88299fac0f6daad66725693a5905b"
    sha256 cellar: :any,                 arm64_sonoma:  "f9bc81b28834d988e5779db9ccef8f2f68bad8679f6d34d47c7440da99bf8875"
    sha256 cellar: :any,                 sonoma:        "c9ebb65c4fd49ebeb4143b46360836d0a2bdc09305b37ef1d171ee58e8115424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff48fe8a15e99dd281c6692c6fc66b463f864254fb0026f7309df88f5ae11f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3defa741a14eaed3eedf0f5f18eea42a94ce4388be4040a68eb9842a548ca2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
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
      -Denable-pipewire=#{OS.linux?}
      -Denable-portaudio=#{OS.mac?}
      -Denable-profiling=OFF
      -Denable-pulseaudio=#{OS.linux?}
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
