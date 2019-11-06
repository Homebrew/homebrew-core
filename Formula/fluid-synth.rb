class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.8.tar.gz"
  sha256 "0c37e72db31d1b35e587b94b7163d68444cffaa9e7fe8a293d79957620bff117"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "13d2bf0b969b56d78d547240e06e15370d25195f19a2a4701094a6b0df7331bc" => :catalina
    sha256 "a396b0641cbd0114486d0c49c61e917b1fdd7d9808a26fdbfffb6163ef244461" => :mojave
    sha256 "311b1036a55e065c4b257ad85f07368f52ac832936d09df9ebaeba9af93e1e3b" => :high_sierra
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
