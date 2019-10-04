class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.7.tar.gz"
  sha256 "b68876d24c7fb34575ffa389bcfe8e61a24f1cf1da8ec6c3b2053efde98d0320"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "36d935d2d9d1b95708a72b25c4e52cdb81fcb17a54826e3e60c83f819198223d" => :catalina
    sha256 "79d936e1d1627aa456768e4098ed76d69ed061d7ee94d7c025ea281a374d6bc6" => :mojave
    sha256 "34ef2f21934a46616faea0c805089725d7d62187f3c8c77733a08fc53b905a4c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

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
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
