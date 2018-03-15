class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v1.1.10.tar.gz"
  sha256 "b74801d0fdd726c4555149bf075b76dc4074658ec0a8f7a3753f4a64589e5300"

  bottle do
    sha256 "9764daf9d3faed501a25ca39454150fb0a46e53329fa8db8b2624060ab6750fb" => :high_sierra
    sha256 "609d913be21e9982299855ea363d842023b686a39748ffba34975e3ec2d7d8a8" => :sierra
    sha256 "c39c0d78cf51023c38a4304bbfbdabea9d75297c7136c1ac664b9a26a137b1ca" => :el_capitan
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
