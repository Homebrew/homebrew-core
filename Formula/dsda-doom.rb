class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "caad205a35a6339f3a73019b17818c214de4f3b7822fcc2350e7cae63a044b8b"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "461e2bb2b2fd6de72decda0c33d83349cb9c613a646d6c59d4d6d1263b42552c"
    sha256 arm64_monterey: "8d5d4bc7d38e1a1f5eb9a7bfd452bc7554579af004024268e5dae60ed7351316"
    sha256 arm64_big_sur:  "6990524cfec0e271877e469ca890be0fda1d1d9ecc8e902651654a8fa5f4f934"
    sha256 ventura:        "78fc51616af111d7715f3802fd929b8d32f81c105ffada9278a7b23398b45349"
    sha256 monterey:       "4465fe819a918ae2e4db6b28c0abd3ce4de4c80464f3287627536ae6ab7a2459"
    sha256 big_sur:        "5d94ace0be85ba85fcfe1bbb8c40ef401165f43c98c08aa199204a5cd0a7da2b"
    sha256 catalina:       "4c25430d4653d99c1dd136a795a2c3bf9033047b1ce8660ba9514abdaa4643a8"
    sha256 x86_64_linux:   "fd221840a8e56a5dee645291ab99dfbe7c3e82085fb84ae32e75b8aa64656056"
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
