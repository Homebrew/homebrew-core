class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.6.tar.gz"
  sha256 "ca90fe675cacd9a7b442662783c4e7fa0e1fd638b28d64105a4e3fe0f618d20f"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c7c394bd81d3482d5b28523a9fbb312722f17ae0e4e7a61c61f410e53f7fdb33"
    sha256 cellar: :any,                 arm64_big_sur:  "03ba66fc22841d0ee3acf2c76b792abc88c8e03405cddc737292e386058c372a"
    sha256 cellar: :any,                 monterey:       "f275294dd468aa18c3982eac40470e8d9aeeec4e1cf0c0be95838095c41f0848"
    sha256 cellar: :any,                 big_sur:        "88046350601b301ff2076280f29f080c5e4411ec272d31d6f8f837f8fa39f5cc"
    sha256 cellar: :any,                 catalina:       "06ab16868567af77a57a1d8ca45a4a11aee4c097df9d10c0d9551b763850914e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6137caaef3416fba2c0fc1c9408fb162533bdc43e7a26310600f6bfdbf6ef4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

  resource "homebrew-test" do
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
    resource("homebrew-test").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_predicate wavout, :exist?
  end
end
