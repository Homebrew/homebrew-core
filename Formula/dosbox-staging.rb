class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.79.1.tar.gz"
  sha256 "43f23fd0a5cff55e06a3ba2be8403f872ae47423f3bb4f823301eaae8a39ac2f"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "75cc3a72f4674ea537d12afad7fe9d14617ceb7f1108c01894f880954b3df1df"
    sha256 arm64_big_sur:  "920b3320cb2f390130f7b58c1e16a13c515781f7de9211103d3cd89effea6f4c"
    sha256 monterey:       "de5c5f3431504c34b844a7bd4eae17acdc3d9a7f060ddc92aa8e34512b055535"
    sha256 big_sur:        "9968e4e15dc3618d1c317e09116ef6598520819834938d42a9e2cace23c78451"
    sha256 catalina:       "e36de3ab5208617a4320803ebe82a451ba2eb68dd8a8cf979abcd09e48b308fa"
    sha256 x86_64_linux:   "896b1cd20426b82af5611950a78fa9298adbb56b226de1bf07c9741455a4833a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"
  depends_on "speexdsp"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    (buildpath/"subprojects").rmtree # Ensure we don't use vendored dependencies
    system_libs = %w[fluidsynth glib iir mt32emu opusfile png sdl2 sdl2_net slirp speexdsp zlib]
    args = %W[-Ddefault_library=shared -Db_lto=true -Dtracy=false -Dsystem_libraries=#{system_libs.join(",")}]

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
