class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.5.tar.gz"
  sha256 "69b244512883491e7e66b4d0151c61a0d6d867d4d2828c732563be0f78abcc51"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "0dad5a2972f67dbb9d9b8a1b44474e2c54991a5e3dce18cb0baaa2712023f70c" => :mojave
    sha256 "7733d5ba43ad6d8424375fdd174c4c30e137a29d91fb6d0db90f0531f30b9967" => :high_sierra
    sha256 "a3285524c60d898d66435e6c0ac5e6b0a86081ffa9c364bfd7139d8f4b4f7a2a" => :sierra
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
