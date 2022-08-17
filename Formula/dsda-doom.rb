class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "d4cfc82eea029068329d6b6a2dcbe0b316b31a60af12e6dc5ad3e1d2c359d913"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

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
    # Patch for Linux builds until kraflab/dsda-doom#122 is merged and added to a release
    inreplace "prboom2/src/d_deh.c", "uint64_t", "uint_64_t"

    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(prefix)}",
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

    # We need to move these elsewhere so we can symlink them to the right place in `postinstall`.
    pkgshare.install doomwaddir(prefix).children
    doomwaddir(prefix).rmtree
  end

  def post_install
    doomwaddir(HOMEBREW_PREFIX).mkpath
    doomwaddir(HOMEBREW_PREFIX).install_symlink pkgshare.children

    # Make sure `dsda-doom` also checks the DOOMWADDIR in HOMEBREW_PREFIX.
    doomwaddir(prefix).parent.install_symlink doomwaddir(HOMEBREW_PREFIX)
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
