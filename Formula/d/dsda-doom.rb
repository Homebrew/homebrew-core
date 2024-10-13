class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "31f6c8a8707625ff8f47c65d4821fca59b084d1153d0ac2aa215dabc7108a91a"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d4e2ccab37036b645fa2231a35192821636bd19cf98187fdc25c6583cb755076"
    sha256 arm64_sonoma:   "359b7e1a81d020b38b7dc6287c6f60972856800e01fc9cc1a15940fa25437471"
    sha256 arm64_ventura:  "1398fc65c31d451ddcb211996ff7d943423a5b4d9381b05a071a5a0a48e7a0c4"
    sha256 arm64_monterey: "c7f4f8bc2a7e986e3c0ad0a4e1088054d383b03a69c3e3581d59db174a592133"
    sha256 sonoma:         "a78ac514eae403080fd5eaa49eae5caa5271096036767548fd3d6002b00dff35"
    sha256 ventura:        "021b491c09132d2dde8fca6a04ffc4ad37b095675550b5b13ab9f90a564eef6a"
    sha256 monterey:       "5d2bf9b4364e72f54858a6876e9eb754ebe3e649c632f897022440429d51e242"
    sha256 x86_64_linux:   "e72de95ce47417de04b74b5e50a4d39daf0095479d92dee8114a26a492da3136"
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
    ENV["XDG_DATA_HOME"] = testpath

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
