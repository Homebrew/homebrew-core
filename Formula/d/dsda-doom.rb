class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.5.tar.gz"
  sha256 "5e01be417033e1abf708bb22509d4d910b158a159a2790c4d5b46690daba67f0"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ae9d41065eab382aa05fa2336596aa74da372c87eb8d64cf71946f9576c37947"
    sha256 arm64_ventura:  "96210b4f7fb9c4c92a6df291c2d4ed6de2670129325359efe85997ba3cef96fe"
    sha256 arm64_monterey: "53c0f6f7bd3136ba9203db9b2815c0faa52ec30667ae34875c553d391f948212"
    sha256 sonoma:         "5ae8098b88dc69ea6411dbc6ad95aea4e8e9c4ad9b0fe26185bf577c58f04c31"
    sha256 ventura:        "dfd1dbb2f8da602147d652f809d6f2f79eb21a532927f56248d726c9ebf63b51"
    sha256 monterey:       "c8afe23068fcefc108567f2ac07f9c1e98a1aaf259c021b1f9e13082d02158f4"
    sha256 x86_64_linux:   "1f4dead38e177c76badd2618757a679ea4ef103aaddf42cece93788be99a11de"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "fluid-synth"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "mad"
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
                    "-DWITH_DUMB=OM",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
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
