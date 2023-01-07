class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.80.1.tar.gz"
  sha256 "2ca69e65e6c181197b63388c60487a3bcea804232a28c44c37704e70d49a0392"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "1427f1f931c4150a939bc7b7617dbfb8bc92f7fb94e4a18aadc75aefc4e561a1"
    sha256 arm64_monterey: "082a32877a34dfdf8c2991bf482fa308eb502ff784ff59e8d78af920765b23e5"
    sha256 arm64_big_sur:  "4e3cf9ec624eb11055fb8b3a3cb1490af2b622e74c986714c00e06194bf97e32"
    sha256 ventura:        "6d875ea527d93563513a2afc91ccf03324be4a351e8e971d3b198974f0891d2d"
    sha256 monterey:       "438de7ea5997b1589f0a70d69f4c66164801b75e2c09087f4b60bb8884d02104"
    sha256 big_sur:        "38b00a9d5a94fe8e00db9e5de9b14d1285bee310ea635c0340d40c36cdd9ecf3"
    sha256 x86_64_linux:   "c17546040d2e84f48fa2388e83f701d52eb795abb32f3d2aaf03d1fc1f8cbd12"
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
  depends_on "sdl2_image"
  depends_on "sdl2_net"
  depends_on "speexdsp"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    (buildpath/"subprojects").rmtree # Ensure we don't use vendored dependencies
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
