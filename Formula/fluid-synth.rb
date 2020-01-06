class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.1.tar.gz"
  sha256 "966d0393591b505d694e51cbf653387007144e9ae0b8705d82ec7d943d31d348"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "13d2bf0b969b56d78d547240e06e15370d25195f19a2a4701094a6b0df7331bc" => :catalina
    sha256 "a396b0641cbd0114486d0c49c61e917b1fdd7d9808a26fdbfffb6163ef244461" => :mojave
    sha256 "311b1036a55e065c4b257ad85f07368f52ac832936d09df9ebaeba9af93e1e3b" => :high_sierra
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
