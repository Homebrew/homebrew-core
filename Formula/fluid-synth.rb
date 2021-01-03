class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.6.tar.gz"
  sha256 "328fc290b5358544d8dea573f81cb1e97806bdf49e8507db067621242f3f0b8a"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "7ee150a66363d55e5df6bd1fe41098c4d5b1ccc011b854122a36bbeb0216c2fa" => :big_sur
    sha256 "aa1ff86798a73fc051ddce24ee85b04e656730d227dfc210b716eef694f4e6b9" => :arm64_big_sur
    sha256 "243e9a0d120f1ff90193396be36f47ef9f3309cc33230bd3fae32e313d45f12e" => :catalina
    sha256 "67056fe2f9ed53190384c9a7776e81fdb35e23a265a54b3df1c16673e7c302c3" => :mojave
    sha256 "028fcbb7878f8a1f48db5d0af058c04c934a548e8215cec11b1bcf63450d42ba" => :high_sierra
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
