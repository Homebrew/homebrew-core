class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "d4cfc82eea029068329d6b6a2dcbe0b316b31a60af12e6dc5ad3e1d2c359d913"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

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
