class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "3340d73286b28fe6e5150fbe12648d4640e86c64c228878b572773bd08cac531"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a15f3dbb5d67e6269105878009fa47ed86c8b66d3912c83080ea635545c22ca1"
    sha256 cellar: :any,                 arm64_sonoma:   "8df2c2ec0acb05d03fc8b5e2abb2d1a5d1613ccf632de3928a24f0ef88cb7abc"
    sha256 cellar: :any,                 arm64_ventura:  "4764cbb6fa6ab23bcedf5e2e93041c1868cbc8e5ae51ea7df33c660d75490bbb"
    sha256 cellar: :any,                 arm64_monterey: "2ce96a15edff1143f7fb074901acbe574d3538dd2a62d94af37b679a506fb71d"
    sha256 cellar: :any,                 sonoma:         "8821d94c5317df25fdbc01186eb076b27d0d266ecd2178749b2a872adc74fcab"
    sha256 cellar: :any,                 ventura:        "7da83508e3fe26ebe0cbf6c4c4893d3e4f25de13a9cbfeb6385dbe45d71d6c59"
    sha256 cellar: :any,                 monterey:       "85308fb8e2e6b859570ccd9896a71580febf918b118d7296c211efac1df0ed99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97aae8459de63e3a11aa348d5bbc3758bf6e346f9a6ecde6edb041f834865c97"
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
    assert_predicate wavout, :exist?

    # Check the pkg-config module
    system "pkg-config", "--cflags", "--libs", "--static", lib/"pkgconfig/fluidsynth.pc"
  end
end
