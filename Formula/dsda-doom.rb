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

  def install
    # Patch for Linux builds until kraflab/dsda-doom#122 is merged and added to a release
    inreplace "prboom2/src/d_deh.c", "uint64_t", "uint_64_t"

    system "cmake", "-S", "prboom2", "-B", "build",
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
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--install", "build", "--config", "Release"
  end

  test do
    expected_output = "IdentifyVersion: IWAD not found"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
