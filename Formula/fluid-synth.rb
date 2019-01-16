class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.3.tar.gz"
  sha256 "12c7ede220f54a6e52a7e7b0b1729c04a4282685569adf18d932a7dd3c10e759"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "ca4ff3361765e4b25b16d621b96a7abb87ada037d0f309f34bc05d4edb9b76a8" => :mojave
    sha256 "65d6ea5d48f04308d046b83b201dc9eb177c1f36287873d182d3cbe16e374263" => :high_sierra
    sha256 "c00727a551aaa9e5029a985cb6b30bf20d9d5440e73859b662f91be149ebb5c1" => :sierra
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
