class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v1.1.9.tar.gz"
  sha256 "dd6321e13a7c875ef3032644bd3197e84b3d24928e2379bc8066b7cace7bd410"

  bottle do
    cellar :any
    sha256 "b723c0e4895e284361142a3f9ee871a1519a230ab5eac4d2e816a651ec1953b4" => :high_sierra
    sha256 "1ae6a117a7850abd29df4d47c740eb2734a057bee5e5708da76eb21ea1770e3b" => :sierra
    sha256 "442615894ba807164a8f80387d2d0e193ec2466b82f5f4b55afd567448edb32a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libsndfile" => :optional
  depends_on "portaudio" => :optional

  def install
    args = std_cmake_args
    args << "-Denable-framework=OFF" << "-DLIB_SUFFIX="
    args << "-Denable-portaudio=ON" if build.with? "portaudio"
    args << "-Denable-libsndfile=OFF" if build.without? "libsndfile"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
