class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.4.tar.gz"
  sha256 "2c065de87e9c9ba0311ebf2f4828a4fd76f1f5cc7d1d93dd80d7a048d7d2a76c"
  revision 1
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "096098def104dbd267e2bf16c6afa0298df4e40372d14310617e9bdadcdc6913" => :mojave
    sha256 "404d3ba14185d4593d269270591c6978203365790ff014b643e732a518784ffa" => :high_sierra
    sha256 "b9e8f11bdde68b9f0264154b95ef58d4ced5949ba1d71c1bef6f25403b23c33d" => :sierra
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
