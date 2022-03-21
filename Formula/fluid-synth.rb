class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.6.tar.gz"
  sha256 "ca90fe675cacd9a7b442662783c4e7fa0e1fd638b28d64105a4e3fe0f618d20f"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e5f04b2d86818ecb8baf1bd0e1ec5aaf8346260219a00ae82283ff2a9056337"
    sha256 cellar: :any,                 arm64_big_sur:  "54addcea68b96dbd8c53845da50afb876ed52351aeba00d3aac274548e87bfe4"
    sha256 cellar: :any,                 monterey:       "2956db008dacf30544dd12c555ecb57598bfe761a9f3da67600ce1b080044365"
    sha256 cellar: :any,                 big_sur:        "3168ce2554894fc70a0859943f3691c982aa0f707b39ab62396d4eae4faf317b"
    sha256 cellar: :any,                 catalina:       "6089b7dc8c5f51ccfef63f368fa497cc8529ba82d4332ea77e93674690d9f9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "892636115dfab5822b4a6f32810080c3cd2a0fb335a80d3a7eb619ebd9f651ad"
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
