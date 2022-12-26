class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "e030491e4cb7ade1d297164d95286fc1853bb08b2077397cbb4a46c4869b3280"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "13852708b6d504453371019b0de56627a10da952c26fcfedd2bd9adfb41c1ea9"
    sha256 arm64_monterey: "42a9a7243b89072a9df2f95187c369eefcc3da81edb60512861da260fed180ea"
    sha256 arm64_big_sur:  "a42a79ec59a1ef54b8c3725de5fbdb70239e437e38d83691646b6e0be2a4a838"
    sha256 ventura:        "58419807b8d176fde62fa58e60b04cc1e853607f5b65449b52b8e6990ae5bb53"
    sha256 monterey:       "2be15e042049ed8334ca75594e621c5d5dc38446e7fb02e8981bbdb6dfb5a8c0"
    sha256 big_sur:        "0c986114529b7e1a52f6eb8bd519b30e3bf443c4dd1f30a196b1efe22ff1b0e2"
    sha256 x86_64_linux:   "b26ba3da87d7bcedd6996f29b6fbab7013e9a3e223bf27ef654aa97c9876cb1f"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DBUILD_GL=ON",
                    "-DWITH_DUMB=OFF",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PCRE=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    "-DWITH_ZLIB=ON",
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
