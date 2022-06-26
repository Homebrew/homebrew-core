class FluidSynthAT21 < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.9.tar.gz"
  sha256 "365642cc64bafe0491149ad643ef7327877f99412d5abb93f1fa54e252028484"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "23918636b21c7d2f4c617fc58fc9bfbdaffbe371be38a9b6ce1062af4dfc92b5"
    sha256 cellar: :any,                 arm64_big_sur:  "d25c897f88f0f35bce794a51ee17db1056177a3b23a9f35c2c88542d6565bd67"
    sha256 cellar: :any,                 monterey:       "6dc51778ae06ec9e0cfd55fc8b23587e0de968adbb26195961ec225c3af82a80"
    sha256 cellar: :any,                 big_sur:        "3d2d82d9ff0d7ae9df77e14ee1ca9e160ba2cbc0d7cc6b96b1ec2de872472362"
    sha256 cellar: :any,                 catalina:       "f96a93cc69dbc29048d04a00f6034b1ef3df1f088b9a893ac0744b5d11ba6189"
    sha256 cellar: :any,                 mojave:         "553ad2667f43d1e0a45d7393fb1452de3459832603d792caab7b7d784bc95857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ebdb995ed2864a7ca079cc41392d7b1abc3740ba4ce70e7531978bdaaa72770"
  end

  keg_only :versioned_formula

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
