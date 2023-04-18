class FluidSynthAT21 < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.9.tar.gz"
  sha256 "365642cc64bafe0491149ad643ef7327877f99412d5abb93f1fa54e252028484"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71afcc8322c55d1a73059d8a3685098e86763dff3f109614523feaf07e3be553"
    sha256 cellar: :any,                 arm64_monterey: "00670226b18c2fd801117d763935ca49a6ca21609f4ac696b84f857a6cc8fc01"
    sha256 cellar: :any,                 arm64_big_sur:  "e689296767b10fcfd0bccceee71823c5a3e20fdbcc8ea2d4edc15c8e363bf9f9"
    sha256 cellar: :any,                 ventura:        "ae5426051ce49292887cfed4c7f9abb3757e0e5048451484b09b2755502d15fe"
    sha256 cellar: :any,                 monterey:       "819653c2a980f6db38bd507c42f47e0e3868c0707883620a6c31734eba69c48e"
    sha256 cellar: :any,                 big_sur:        "92556a962e7bc37c737d06838be2cca1b0b6285f19ff1d60af0be4a02b5c9651"
    sha256 cellar: :any,                 catalina:       "d45ae14c3fca7ab441f61d427b4c1f35dbfcfebc6dda8660e28d703ff95f57b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdac8b804f9e2d58ae2b661e867d6a78434e8af6d4db3699486862d93a34390a"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-08-15", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "readline"

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
