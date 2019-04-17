class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.4.tar.gz"
  sha256 "2c065de87e9c9ba0311ebf2f4828a4fd76f1f5cc7d1d93dd80d7a048d7d2a76c"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "41d1a846cf43c9bd44c12916f90a54e1a54c647c5826f584e2abbf8f6f09682f" => :mojave
    sha256 "1108f6f219cb1fbd80b4a2d917fbe2b36325cb93163de01fd157fe47a64ce0aa" => :high_sierra
    sha256 "d76812fb21a4956ba0272f2d39a643c30b220c8e89bbce038a493cebca2cc0bc" => :sierra
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
