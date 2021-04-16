class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.8.tar.gz"
  sha256 "a254efceff5d99f8d658d12d25318317f37307e6df852ec9baeb7da173496967"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7a23f453f4fd75294bd7e7b0541ffbc9c9a18fb28d8507d148a9be831a2a2c65"
    sha256 cellar: :any, big_sur:       "22d00ab29642f02aa58eefde67710a82bdfc80b60d0ccb717e8da12c18af389e"
    sha256 cellar: :any, catalina:      "2b0b6375dea013e09b2df57a49cb673950a84de753da94ddf25976a2a7787264"
    sha256 cellar: :any, mojave:        "500fee9723095bae0ace372d71e64387f022c7eccac767b7edd8279c3b57b856"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

  resource "example_midi" do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

  def install
    args = std_cmake_args + %w[
      -Denable-framework=OFF
      -Denable-portaudio=ON
      -DLIB_SUFFIX=
      -Denable-dbus=OFF
      -Denable-sdl2=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "sf2"
  end

  test do
    # Synthesize wav file from example midi
    resource("example_midi").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_predicate wavout, :exist?
  end
end
