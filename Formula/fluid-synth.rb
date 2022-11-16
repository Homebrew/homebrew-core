class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.3.0.tar.gz"
  sha256 "1df5a1afb91acf3b945b7fdb89ac0d99877622161d9b5155533da59113eaaa20"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab8f4874a8336e7da16f8016ae7d6dcbc77c9a85743307b07a1013fffaec134a"
    sha256 cellar: :any,                 arm64_monterey: "2cf2c3338cb090b11eb7774f13573851faec92a8581424a41cf7255336520953"
    sha256 cellar: :any,                 arm64_big_sur:  "762702137ad043fe56b6811abe371bf379d6c3d28bc25e776e256d2e7f2153cf"
    sha256 cellar: :any,                 ventura:        "dce4d8f5228099fadb6ba23eb6645387ad080f9e3a0998c8310927a63131f12f"
    sha256 cellar: :any,                 monterey:       "22a43f4438731dde9dd1eeca118a0275845f85b5856fc86f3c0527498da62b2a"
    sha256 cellar: :any,                 big_sur:        "1dece23c7e6dd927b5e4a391e170167ee0556b59000432c39e24240a5b630bfd"
    sha256 cellar: :any,                 catalina:       "276bbd679385ea63ae67c244bcb5fc70e31f124e6bed3465ce79322f2bd68455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101144c9ea3f7a77672affe16b198ce8d4c40a781fec160b6fe43c635bdc16b3"
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
