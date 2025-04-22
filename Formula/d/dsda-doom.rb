class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "8a9e477c593320e488bbe0d0255ff23df8422869c397da3e222529e6a38db70d"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "62d79a9e28f986ac5d317caf56fe7507d41324233e01ad58fae7f511b68bbb96"
    sha256 arm64_sonoma:  "904eb35ca00eb76c99f65db6d17128670d6741c63a610e95777daccea320ab46"
    sha256 arm64_ventura: "73ec5cb58f3621d80d1269bf98019a8991ca249a9be2166bdede06f3d17fbca2"
    sha256 sonoma:        "6f089e319ad1807a4838fa4e62f90d0722144a994f3e4e72ba0a6bc2b165ce2f"
    sha256 ventura:       "9bbfc89050f4e7f48dd21d7c334c3dda14a9297e1b692b288d9f776326dd1232"
    sha256 arm64_linux:   "e010235a756f7d322ed9cabbacc59b874db7206051e8d5a4586deb2879678bca"
    sha256 x86_64_linux:  "11154eb148709feb22b9e65b4e8f55968023a454d9b90854bd9c8aee0f035e9c"
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
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"Library/Application Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
