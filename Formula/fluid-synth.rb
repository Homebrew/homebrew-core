class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.9.tar.gz"
  sha256 "bc62494ec2554fdcfc01512a2580f12fc1e1b01ce37a18b370dd7902af7a8159"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00e9eac56d931890252b28a0c4421b0c6b4b731c1f921577a5083608e1344387"
    sha256 cellar: :any,                 arm64_big_sur:  "ad718bb31c5af86e83cec2466d1825213397a6a1361e7531c7799927156e15e1"
    sha256 cellar: :any,                 monterey:       "cfa39d4f53ef81598e13aaa7d19bec99b708786a5864c737fb9649c664ab312d"
    sha256 cellar: :any,                 big_sur:        "82f5848299654d3e7b68d30151cdd2809e4df40cf8172d644b24b038b06eec66"
    sha256 cellar: :any,                 catalina:       "53c67e8e7cc89034727026edb6ccfe20b7ffda7b0be2c57d17d16eeb2eb5e8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54423fb18b53e19da90cef6b436eed457aefe3f822b329d3c656468d72020979"
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
