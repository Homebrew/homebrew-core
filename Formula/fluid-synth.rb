class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.8.tar.gz"
  sha256 "7c29a5cb7a2755c8012d941d1335da7bda957bbb0a86b7c59215d26773bb51fe"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35b93658fa2bdbbe8a70ff448a8775275d6b68ed1f16e1ed9a9b0768ceb9a6df"
    sha256 cellar: :any,                 arm64_big_sur:  "b3479efe1caa4f7a5065b722eb4577e8642cdc58af4798b24ad22b190e8eebef"
    sha256 cellar: :any,                 monterey:       "738b3ce10697fe4ece12786c86b4c910183fc1c6686a34cc6eacb7f1159c12c1"
    sha256 cellar: :any,                 big_sur:        "5ff404ff1417d626dc215e30eadd6aaa94a05382dc3ef8a906ecb5e48e34ded9"
    sha256 cellar: :any,                 catalina:       "892617828f3a4dbf4e55c615bde4178e951c8ac63af680d63468c06c68a05ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1a85efc4a73ac9dbd4c9eb526eead19e57d30add5a6cc47d1adcfb03fd25cf"
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
