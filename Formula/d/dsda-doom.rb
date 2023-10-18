class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "f9f76125b9ffb5be98de175f1e9839b4f563d0113edbe21c4ebb048da714b1d2"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "45d2a26ec0d81842e7d05382303cf49e3522b26f9b73b33c0eb4cc17fc3ef9c9"
    sha256 arm64_ventura:  "47cdcea400de632ebc88a53880224a864db327ab864bd7f673a933f6c1ceb6e8"
    sha256 arm64_monterey: "535ddd3f5044a12b80d735faf70b151ecf8be6d413d168f8ee4640a123607190"
    sha256 arm64_big_sur:  "052c0f60ac8267c96fac699d5bfd4e21a4af612d07772657c3216f1181869906"
    sha256 sonoma:         "8c1a5e0310dd9ec68121fa436820867272c7e502b993686b13a1bdac103b8eac"
    sha256 ventura:        "263027ee9bb442769114d46e901bbd0aa262d172325169fe41e9c7b0eb055b05"
    sha256 monterey:       "b0ebf39325d85826550d5eb01b23a1ef4c707cb57d839487e82094ddde4d4fec"
    sha256 big_sur:        "7be3e2016e550349fb5b9c23e6ffa3eb878d92e3495e31aed7153b59825ac899"
    sha256 x86_64_linux:   "957c2940e37fda0555184f780f5df4ed62e3e33f06dedf84128799cd82bca432"
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
