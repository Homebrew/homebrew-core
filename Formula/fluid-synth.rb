class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.4.tar.gz"
  sha256 "2c065de87e9c9ba0311ebf2f4828a4fd76f1f5cc7d1d93dd80d7a048d7d2a76c"
  revision 1
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "21518b88fb29ff104e4141cd7cd077c5573150ac3954bd3cd69e30e9e722d987" => :mojave
    sha256 "1d612e6f3de0f8d81b63c2997d0dc3abdf42610ff257572ebf750d74c84b0727" => :high_sierra
    sha256 "e0599de403e96630e1507674be7582a817f5e868bb023a4c35719afeb9411b53" => :sierra
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
