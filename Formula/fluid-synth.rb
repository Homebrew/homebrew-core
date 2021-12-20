class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.2.4.tar.gz"
  sha256 "83cb1dba04c632ede74f0c0717018b062c0e00b639722203b23f77a961afd390"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "293adfc90a45fc9f7428090379879ab399aab32cb7ffe7d77ca3c47ce4124de3"
    sha256 cellar: :any,                 arm64_big_sur:  "cda7c1ad9e2489a6c6b02e7b758e7074e3e1f5b2d7f874b6b446984d1ce122cc"
    sha256 cellar: :any,                 monterey:       "c7058ff2abcc96941852d03f876d09d74eb9f1cb09878afbaeba356c320f7535"
    sha256 cellar: :any,                 big_sur:        "b992c40a8813ac566457f36cb9ca527c332971f2873195d421764720c7039314"
    sha256 cellar: :any,                 catalina:       "262da53696871ab8a46996c5af8611e0d40ca3e5b0dbc550efc1ed290426c0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440d60315a01f4e0fcee54e8e30a20bcd9d27efcf6e8246240ead3697a0c1f1d"
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
