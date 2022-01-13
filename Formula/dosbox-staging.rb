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
    sha256 cellar: :any, arm64_monterey: "1582c58614778487dbd1db8865f4d48da778b8b705d86b4e1a5a0a9b138007ae"
    sha256 cellar: :any, arm64_big_sur:  "ea91d5a56b9629996f80724521195de779fbcfc1866ec65a0a9bf4aecc0e5126"
    sha256 cellar: :any, monterey:       "bf526bfb6ff092be2c906fc3639e951fc1c4a38256790e91680ba0f5c789b74a"
    sha256 cellar: :any, big_sur:        "1bcf72092ca21df66b7f20fdcb21b78120e6e593ca6172012c87dc7e85df9395"
    sha256 cellar: :any, catalina:       "f4d2f3d4b924d7835efef8edad01c04eb585f2b2a1538e1004909ac8591ee4da"
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
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
