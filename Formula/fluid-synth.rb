class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.3.tar.gz"
  sha256 "645fbfd7c04543c6d3bf415eab8250527813b8dc8e6d6972dbcc8cb525e1d409"
  license "LGPL-2.1"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "20b95c9a3233fb35ea30f4942e7bd9d9c5eb560ff471bece810aa9b0b753615a" => :catalina
    sha256 "4bb28e3e5539e606f6fa41267a483b3cad254918ecf4859402a30d524a9598b7" => :mojave
    sha256 "8f55c689efeaf1dd86b761bb8c026bb87f71262411686d8bdb00cd068405c19a" => :high_sierra
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
