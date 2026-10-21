class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "c8b14d5e6f5aba66745cb682297fe3aa97f3ef158d7f876798dd213a82e1de40"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f11498404f6c09aee804976c0f4c0efe8db6a798a427844b5ab00a6f3e3bf28f"
    sha256 arm64_tahoe:       "f69ffe34c83585fb282111da97cf20a30f06466235a613a10079819e17ec0f3d"
    sha256 arm64_sequoia:     "9512ee640ecb4545671beea06cda5b84bc564d7a8fcd67577356b23075ab86e9"
    sha256 arm64_linux:       "90bbe4a5c71723642f3aed8ff3cf574aa6e0db46927a2f731895a3f7e7229682"
    sha256 x86_64_linux:      "95dd0075d10612180013c782787e338e93cc3b56ab7d73922ea78b6716d1d296"
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

  deny_network_access!

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
