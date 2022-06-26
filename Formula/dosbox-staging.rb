class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.78.1.tar.gz"
  sha256 "dcd93ce27f5f3f31e7022288f7cbbc1f1f6eb7cc7150c2c085eeff8ba76c3690"
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
    sha256 cellar: :any, arm64_monterey: "1d186ea2c0a3ca07ffa8c1ddd02d34832d7c50d4c718dd50c7aa5469489e4901"
    sha256 cellar: :any, arm64_big_sur:  "92315173b7a51d4af3db388cb65420026d7864aa27f5ef89a03942bf42afcf79"
    sha256 cellar: :any, monterey:       "7ca82e1f018eebd2650823754122b999dba06cd3c923edb7fec0cf07d356e54e"
    sha256 cellar: :any, big_sur:        "48c5d2212056baf6bf7cf5ac1db657148322f8e90a70fd065f11df3dc0262e98"
    sha256 cellar: :any, catalina:       "12ee01a5d78a0d1b24c51deccc311b2ab8bddec499265c088d5174a16a49837f"
    sha256               x86_64_linux:   "357fb2f803a354e6662bc8bb5468bd8b02d66190f0b29c7270bd9dd1e08799bd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Db_lto=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
