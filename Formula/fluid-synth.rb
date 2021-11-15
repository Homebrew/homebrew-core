class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.3.tar.gz"
  sha256 "b31807cb0f88e97f3096e2b378c9815a6acfdc20b0b14f97936d905b536965c4"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7a3375ad94fc3536c8a8e73763a4f6a5b239da1bde4847ee9766afdbc5073da"
    sha256 cellar: :any,                 arm64_big_sur:  "57b1c20d591b10710d8925d9dc6ec36c59de7cc29f38fbbcf3227781647298a3"
    sha256 cellar: :any,                 monterey:       "dc1c93485c360861c9ae0846fed81ef72d85349ed128dc2a26a93f99f000709e"
    sha256 cellar: :any,                 big_sur:        "df4608a36dba661b05360b0ce0f7b83c6a1d520a40f7d405f72a416517a01551"
    sha256 cellar: :any,                 catalina:       "0ba416ec67f720ec5c3e2542699b93d53c7ea104dd101e1e794c9066828c00b1"
    sha256 cellar: :any,                 mojave:         "9b26d7238abf5cf5fa3215ffc5c53da254cc3c9b020fab2922b3e7065ecb2384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ef1dae7d024c05e9e268da2353fbf04de322d38a33f9f8e45c1d565cb1f7ea"
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
