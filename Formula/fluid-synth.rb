class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.0.tar.gz"
  sha256 "1df5a1afb91acf3b945b7fdb89ac0d99877622161d9b5155533da59113eaaa20"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2793cada9256d57f4fb2b79d783881ae7ffd7aff28ff651927027db0929e73fd"
    sha256 cellar: :any,                 arm64_big_sur:  "12d0bb03576b49f405c8beb9465af51c7d66cb30ca5b1e64bd0b52916fde0f83"
    sha256 cellar: :any,                 monterey:       "169333278c8b6992d479a5d5427f5821a5036b5d90374d077311afc891982370"
    sha256 cellar: :any,                 big_sur:        "fc9f4f39e20f2731eab92098f53ad2a4067a5940de641b3f50eeb5909bf59084"
    sha256 cellar: :any,                 catalina:       "f2f562a458d8388043e12612739503f46b4ebce9c7a371c83364f748db597254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a9759b6c50bc1bf26b87ead514628ab27ae72c8df68064dd98bba1e9efc004"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "readline"

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
