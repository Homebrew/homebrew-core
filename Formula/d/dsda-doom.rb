class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "9b9218d26055d2e2a3b830913cfe52f56b2a6dd4a16720634f0bc5dbe560fb84"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "a055e107d33729ce1251c9d4dddab9ec29c4df7e62e96875da12d8405ed669fd"
    sha256 arm64_sonoma:  "f39be35e19a405dfb4f2d19959cc937f64f9d8f7df14ba877ae5e30b0032991b"
    sha256 arm64_ventura: "891630b837903ceff3bb20177bca6ead60f6d488f5200062e02a2c93b57466d1"
    sha256 sonoma:        "45485a08e04fcdb05c0c2786431ea68a494032db0b85a494c59a389317a3f03e"
    sha256 ventura:       "e9a0cd7a8aad28b0c20c588e82b0517ecf84d8b910a96f4b4e5f88bec6efc4fb"
    sha256 arm64_linux:   "9b892f7df0a302c769bc55e2314d6920ba8d5c9932abffdebde0c25cfc8e27c9"
    sha256 x86_64_linux:  "ee6294b5d234e411f001f709e963a008dd39a15586295283610337be1b8e1f8f"
  end

  depends_on "cmake" => :build

  depends_on "fluid-synth"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

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
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_LIBOPENMPT=ON",
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
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"Library/Application Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
