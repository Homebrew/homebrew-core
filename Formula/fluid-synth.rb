class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.2.tar.gz"
  sha256 "695aedbfd53160fef7a9a1f66cd6d5cc8a5da0fd472eee458d82b848b6065f9a"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8fe2aca69644b92a6af1d741d1fe9b22676b5410ac19fc6c1a720de4a6d9663d"
    sha256 cellar: :any,                 big_sur:       "fc6be35f952494164dbed22d99b3be8a3271e45cba3cef64f1b4125d401d49ab"
    sha256 cellar: :any,                 catalina:      "b151673f02fe9138e5b9eb47d6064b45ad81ca81db355fae45648a49233f0fd7"
    sha256 cellar: :any,                 mojave:        "ab830fe18dcde94ad7c7bb87c64b94f46a6f617549bf9f19b1d3e78988a747c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82884a9091f88d57320fd1eeb29d9fc1757247d1ba94a98e194005c97adb5bd"
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
