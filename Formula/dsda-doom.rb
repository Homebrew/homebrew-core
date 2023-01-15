class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "9855cdb2f403058cd81947486e86fa9c965f352360b0743af62c26a09174825c"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "9f4c1c882c9eacca0fe546c03b9c7f7454c26f3c9cdbc71f41999beb80da77a5"
    sha256 arm64_monterey: "757adec6f8c3f5dfd33a25d5204495cf83b4f9736793864a14b0faae6a9b9b1e"
    sha256 arm64_big_sur:  "312daf9705233396ec4a4fac888e5da42027e7409e26ea4c8882415943924cc9"
    sha256 ventura:        "5777816585bd4fe67d5d6e96029e5603e0c5bd7951b5abb68072d161611c7cbd"
    sha256 monterey:       "b11a029535d4a605fb82cb2c4dd13e7931fb3984426da9bd3384f3a1aaccd9c7"
    sha256 big_sur:        "a39399cade3dc5cd77e13b8ee8702e8f4f06f41ac22e62ec6a5dc19d55f1eac6"
    sha256 x86_64_linux:   "834968140a64e868a654bce0b97a4509df23c24584cfa30bc972d36b0955f862"
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
