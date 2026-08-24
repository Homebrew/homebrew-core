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
    rebuild 2
    sha256 arm64_tahoe:   "15c0a32900bbf971c5b7758a03cc4b61a2f0db53c5ff254e631e0b2cfe9f8f06"
    sha256 arm64_sequoia: "689d26af598ac1a327a18d6883252e5534815db0ecca891284b4937ec4b374b2"
    sha256 arm64_sonoma:  "0a324c2ff0906654bac84e2f9da9ee7a546f9d877ff42ba161cfd3ab5153a515"
    sha256 sonoma:        "1652649499a950c253f5c67c07025947a5e38bb775113ce1788c91a4dca0087e"
    sha256 arm64_linux:   "f23bd0d5da42072a33111733dc060f3c840e5702912099ceb3190d8743577407"
    sha256 x86_64_linux:  "8f4ea27fb97d991806bf690ff9cc756979824672dd7b3f3184bedf28a4663923"
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
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
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

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      parent="#{HOMEBREW_PREFIX}/share/games"
      if [ -L "$parent" ]; then
        original="$(cd "$parent" && pwd -P)"
        rm "$parent"
        mkdir -p "$parent"
        if [ -d "$original" ]; then
          for child in "$original"/* "$original"/.[!.]* "$original"/..?*; do
            [ -e "$child" ] || [ -L "$child" ] || continue
            ln -s "$child" "$parent/$(basename "$child")"
          done
        fi
      fi
      mkdir -p "$parent/doom"
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
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
