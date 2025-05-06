class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "9d943d6610b6773cb0b27ba24904c85459757fbbfa0f34c72e76082132f77568"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "f1f4a11754e2436d48f1d40742cd8fcf904f07dfd53ac72f9547e95038483c91"
    sha256 arm64_sonoma:  "1afe5ab249e2156bbf89ae26a4e3871d9cbe19fa4de181fba3cc7d4802608b90"
    sha256 arm64_ventura: "98e19ac0908a405094467dac092283e5192fd345c4db7d93c3d359bb9c5a9f66"
    sha256 sonoma:        "c6e67a8dd5578cf145a91d233f7dd1ddc2f123ecb2fb809984acfcee086897ab"
    sha256 ventura:       "417312bc7fdff60bb2ce34a73ef03f3043df6270c67377bdbcab99807feafb78"
    sha256 arm64_linux:   "a3dd6ea049201e66f43fc13cf224acba602504ae8121c691c0c6a218bb0befb1"
    sha256 x86_64_linux:  "7f20a8e4df3043ab401343c7178be0431a3bf8f16d4928c6f33ffd4185a9b2d3"
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
