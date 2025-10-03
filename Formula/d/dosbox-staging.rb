class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.82.2.tar.gz"
  sha256 "387c97b373c3164ab5abbbc2b210bf94b5567057abe44ee1e8b4d4e725bd422c"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "08e2afb5389649c1da8e0242ed58cb937b6f95231383aa78aee2eddbb478b6d0"
    sha256 arm64_sequoia: "67bbc49e8ce9292918ec0fe1bd6155ddda3260ef7f840be35a562f2d51fbfdb9"
    sha256 arm64_sonoma:  "7400c7d85ec825c4aa117fd41a3d0d91f630b4dd6f4eb66df9941a31796f9dd1"
    sha256 arm64_ventura: "d0907c011b0cb842686fe223cddbb4267279c9b1a6e1d213f29c6ce353c045f4"
    sha256 sonoma:        "2ad78b97010edb15688741a486ab570cbc21479e745a189aba2647e6e6c25492"
    sha256 ventura:       "30d04f3c8adc6a210c39ff2d6ee4c6f70b8013f27415c12bac4e76acd0583d39"
    sha256 arm64_linux:   "f6ef8be8b1eb88195f99f7fc76c24b902f56ea449a6a3aa223675854dde18518"
    sha256 x86_64_linux:  "5886d49c71e462a00183ed14a7c8aa39b1381c2e199315de86ffae3d137db515"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_net"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    rm_r(buildpath/"subprojects") # Ensure we don't use vendored dependencies
    args = %w[-Ddefault_library=shared -Db_lto=true -Dtracy=false]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
