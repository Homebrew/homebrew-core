class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.7.tar.gz"
  sha256 "b68876d24c7fb34575ffa389bcfe8e61a24f1cf1da8ec6c3b2053efde98d0320"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "90121d7f725289559f16d5b80a980bd6f9320bef18443826d179c14a35cc95b2" => :mojave
    sha256 "3d8e71b6382bd09671973a6319ee68ceee49c7de0debc889ae345ec49f68e11e" => :high_sierra
    sha256 "c200ad90de9fb742ad44e7a63874b6d0409e90ff2c15776d8254cc6f460572c8" => :sierra
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
