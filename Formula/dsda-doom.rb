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
    sha256 arm64_ventura:  "297ca44a9b5c0f2fa14f97f0ef06dfe93af4da395fec0616b242098c88fdf1d4"
    sha256 arm64_monterey: "c546fd0070d101815a82c6779733b7ce465058f7a1c0f89c0752b891b1d0018a"
    sha256 arm64_big_sur:  "10ebbdba6bf641051c2672dd2c5118a91a86265dcbe7820ef4b37ca90510dd6a"
    sha256 ventura:        "05129b2e3ae15c41810b20cdd8a9e83142bbbb52420b8ab31ad7baf32ad07731"
    sha256 monterey:       "64c083d351a30165e80aaf94118486c29e9aeb1ce6ac10ed2ac37668f029a34b"
    sha256 big_sur:        "812646d858dc450ac156304efb85d4b04ea0641868034bfaad5d1744f9d4017c"
    sha256 x86_64_linux:   "ed5a85c2b7c429885171838505b8fe8aecc13c73ebc6711b87c80aabefaafebf"
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
