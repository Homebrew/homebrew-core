class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "88e51eee63058d2bd22c478aa82922ba76fd01aea8073350483c7e0deec4fe1e"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "8e3812456b495d11837f18824f39a9623efb91b9861906422e2370603876b3de"
    sha256 arm64_monterey: "2e74a681022f29260092ede34518217c38a27ceeaa739136793f9564e075f69c"
    sha256 arm64_big_sur:  "9a5da0a4b5377576f226dc2f6a18a72e1763a2e932ed7e291f36969242f7ba24"
    sha256 ventura:        "493a1abe76482792f4b1de62a3653fc479cb2326c61025b1417dfd0367e1ed0a"
    sha256 monterey:       "8a2a430b1f368ea96651239577f824e09e8c82f0b5e7f790ffe18f246165c8b1"
    sha256 big_sur:        "09d06a013eaff9b9034b4cd2bff56934f6151615885f9b8e2685877a8f06cdf5"
    sha256 x86_64_linux:   "41b544176844919747e0caa317b301992da942c37e9e7157d55d40440810a972"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "fluid-synth"
  depends_on "libvorbis"
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
