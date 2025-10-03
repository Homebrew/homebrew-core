class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "d6d04e9014557906ee42aa1fe3cd580840ea482d4c3b1a45fddd45ec606d6e97"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c8aca6b8935c71b30e3c935f9f2c97c62d693b260361d5c88a4f7bbbfae8841"
    sha256 cellar: :any,                 arm64_sequoia: "b1d75ea2ed0bf7b161243fa20f9954632c6bb8faffc4f59cee5319e38773823d"
    sha256 cellar: :any,                 arm64_sonoma:  "865e783a763fe8ba486d7882823f79f9442239bc7e6f51afe68003b97852dc0a"
    sha256 cellar: :any,                 arm64_ventura: "a8d44b962a768a2c1aeb012c6bd49ecd2c1f285d81a73803af0c0804a489da64"
    sha256 cellar: :any,                 sonoma:        "d3d831fc5ec4854a1259e78103083343a2d55b1db20d78a73b65e855a8f8d92f"
    sha256 cellar: :any,                 ventura:       "5ddb17c4b59eb6df476e5952b54d82aa2e0d0a47cd13ef830f4b6b1a704b3998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fb331b937e68d92090539c41c115dda79ab12d2fd3b84ed0d448649c23a214f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc89fea8a3e7b09c69da240ff8ee334c5cfc9435bdb747687219f84fddcb1d89"
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
