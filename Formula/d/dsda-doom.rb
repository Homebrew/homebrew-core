class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "f866db79381862080718668f582b0f358811a016db17680e507abb9250afbea5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "8701e733a61839e8a4dd604f981070c7767340ee1d631e59b359cf6e1956c008"
    sha256 arm64_sequoia: "3aac3390bc253c004d90862f0d3f255f7b8040a006580fb537e6073bc61e9896"
    sha256 arm64_sonoma:  "034195036cc006dcbd1f2421411e96e9d25e37550c726f06043ac3572e03f932"
    sha256 sonoma:        "4ff911beb7b369f23aaeaff11085d13c82415489a7b602f8049ee7608bf97c82"
    sha256 arm64_linux:   "abaabc928dea3ce2cdd7a7ee142f20d7abf49d1abb0ea2b86cf0ca86afe6acec"
    sha256 x86_64_linux:  "d5c2769b080becbee945530cb009a8f67557ed78447bd39b26d32c1f698e90b8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DSTRICT_FIND=ON",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    "-DWITH_XMP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    doomwaddir(HOMEBREW_PREFIX).mkpath
  end

  def caveats
    <<~EOS
      For DSDA-Doom to find your WAD files, place them in:
        #{doomwaddir(HOMEBREW_PREFIX)}
    EOS
  end

  test do
    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
