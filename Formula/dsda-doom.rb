class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  stable do
    url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.24.3.tar.gz"
    sha256 "d4cfc82eea029068329d6b6a2dcbe0b316b31a60af12e6dc5ad3e1d2c359d913"

    # Patch for Linux builds
    patch do
      url "https://github.com/kraflab/dsda-doom/commit/1af0987c190f183d870b6b44aaab670d777df7fe.patch?full_index=1"
      sha256 "800eca74126d991a7490b37e403778a6b2ea764abd7ed4648d48db2d2ccf42da"
    end

    # Patch allowing to set a custom location for dsda-doom.wad
    patch do
      url "https://github.com/kraflab/dsda-doom/commit/40e29a41b39341a579767b5a88030cdf90f31429.patch?full_index=1"
      sha256 "21bc7241ff81db9138f4c7a7cfdfd80f1de6fa4789a501f215f3c876463de256"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d678f7e71e2eb80e55b131402765c634beac3385ab94b414f7ebe45074e2e61"
    sha256 cellar: :any,                 arm64_big_sur:  "478f1e2ee08721d7127b844b84a87f0c96b57fa5666ecba88ebdbc7d03d5304b"
    sha256 cellar: :any,                 monterey:       "916e5d6e9a5dab87d7178f71fcb5fabe79be0f3e7af6814fffbda758d4adb7f7"
    sha256 cellar: :any,                 big_sur:        "934493f52a5d3a6e6e75e1ec6b71c488102bbb56dfe1aa0d650ef7a00020021b"
    sha256 cellar: :any,                 catalina:       "51709e14d5e1e71f408947076713d69afdd7f076ac470035566342c34cf16fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4706bb36f51c9f3ac71b1cec66d3246c8c6d7d65560664ddcc4df80e76d3214a"
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
