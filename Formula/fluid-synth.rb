class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.1.7.tar.gz"
  sha256 "365a1c0982efcaff724a7b05d26ce1db76bc7435aa4c239df61cbc87f04b6c90"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4305044cba000c5d84091d08212a591ee194095d64f58bfd3a2f7774eb74aa80"
    sha256 cellar: :any, big_sur:       "2e02d5f16e66f192a9012c074f4b26a5e6152f75785b31f67686b52fe9f6ca90"
    sha256 cellar: :any, catalina:      "b42d65523f293bd5f684f218954598b7512a7a9ad70f5ee70d4c0d8653267390"
    sha256 cellar: :any, mojave:        "c362af5dc1a15d2d0798b79452068c1f65a98f8604b04734cf48dad22ebba4c3"
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
