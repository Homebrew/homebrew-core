class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.6.tar.gz"
  sha256 "328fc290b5358544d8dea573f81cb1e97806bdf49e8507db067621242f3f0b8a"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "be02ecfb522e79de8f0001da67d09c259b4fc14c8952fddfe08e5c55208386fd" => :big_sur
    sha256 "5713992232cb4c298d5ab200220883393d95ea1081bb362f55a7d2b2ceeddf17" => :arm64_big_sur
    sha256 "55785ce947a8ef644efe4ecdb1358b329174538ec54e81a3f1598e562c1fe8db" => :catalina
    sha256 "200cc4f524be149e679e8c258db12f1ef7843474d4d68636b5f8f22c6d8da292" => :mojave
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
