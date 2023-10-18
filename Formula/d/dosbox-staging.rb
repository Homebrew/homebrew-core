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
    sha256 arm64_sonoma:   "cfd817c8b42feb7363f19012ccf886b8c9f086ac45cc2ea1690f0ece0e25d5e7"
    sha256 arm64_ventura:  "ede878e833eb4c983ef235783dd9159be18acf03b48e686575ad7392d054ae53"
    sha256 arm64_monterey: "72a2fb1f3ec6427ba0fd17a044326d7671d10c780201c4a25d0fd923d6bea5e1"
    sha256 arm64_big_sur:  "cd7582b8a91271b3207f58db439fa7515563f6f64016fb39b12cd829815115b3"
    sha256 sonoma:         "4e5bb8545930d5bea64cde807ddce64722a001fe1c12bee9eb1dfed4dd1a6ec9"
    sha256 ventura:        "07a56487d2a430af500f506f9cca55c5e197c0ce401f91625b78888022b0f78c"
    sha256 monterey:       "6e09bc33484abdecb4d3c0dfbd18995b56175aef5df23954d8075f46dbde469b"
    sha256 big_sur:        "6fb4d0bcc1a8467a6ed4ce36313611e611b313100c26c25592f22cd725f7bd94"
    sha256 x86_64_linux:   "7b747336d0836675791b880ff6dde5490ae0d9ef417e007e924c068581b810af"
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
