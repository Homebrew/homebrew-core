class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v1.1.9.tar.gz"
  sha256 "dd6321e13a7c875ef3032644bd3197e84b3d24928e2379bc8066b7cace7bd410"

  bottle do
    cellar :any
    sha256 "31488d414cb514d3f611da53c906558b15d978e38a168efe6c86b2625fc6be01" => :high_sierra
    sha256 "76ac91d166f0e5b62d3ddf21708e3a336c3bbb363f301f4e698b2da144e209ca" => :sierra
    sha256 "fbf596cb1c9c07d6c078fbe3b679a01e533b36f3dfda851690c7ee624870b8fb" => :el_capitan
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
