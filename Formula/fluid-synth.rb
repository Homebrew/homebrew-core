class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.7.tar.gz"
  sha256 "460d86d8d687f567dc4780890b72538c7ff6b2082080ef2f9359d41670a309cf"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "23526c8b54833babced5175acf047e1e0da4d4a488085e5867b499b4f9db9093"
    sha256 cellar: :any,                 arm64_big_sur:  "9dbbff6586fe7aba8af9635e7eaa232a72003f7184b184779b4dbe362e9af84a"
    sha256 cellar: :any,                 monterey:       "19ac15d032be1590d3ed9a7f0f560340c9c28b3e5aa94e1c31df925509892d9e"
    sha256 cellar: :any,                 big_sur:        "d0f2842b70fe5325c57a4c21aca4308285749da5a0c53d7c33cd5a8e6ad445f6"
    sha256 cellar: :any,                 catalina:       "bcdca41f4d49b87d87481188f11542191bba347085767c0a5b78797935e74a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749ad0826b928f51ee9a5d4c11385f754d0cb1b0715400d41b68ade0ddbdf6c6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

  resource "homebrew-test" do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

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

    pkgshare.install "sf2"
  end

  test do
    # Synthesize wav file from example midi
    resource("homebrew-test").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_predicate wavout, :exist?
  end
end
