class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "f866db79381862080718668f582b0f358811a016db17680e507abb9250afbea5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5cc7555e4275b5668e1fce806478390614ee9b2807089df3e3b66481af31c9b0"
    sha256 arm64_sequoia: "6f82f0faa9f35c0db0b6bcee40f4c9d4c179ec9b28f82fda45fe0a086e49db25"
    sha256 arm64_sonoma:  "171541adf4020cc98ef206dbaa7ff051e9015e46cdc3f8666281f5dd4424f487"
    sha256 sonoma:        "aec8309a2bfccdc7e16304978440401dae23a0e2f0f9776af27f7f3e9d3a2a50"
    sha256 arm64_linux:   "ba6d641574ae6e730884386e56ad258f1d708b43a2e5cf416feca7f1056aadbc"
    sha256 x86_64_linux:  "b359ea353f4a2585139d7528ba4b822267d68f1b26cbc4209278ab3579527f08"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DSTRICT_FIND=ON",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    "-DWITH_XMP=ON",
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
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"Library/Application Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
