class Ddcctl < Formula
  desc "DDC monitor controls (brightness) for Mac OSX command-line"
  homepage "https://github.com/kfix/ddcctl"
  url "https://github.com/kfix/ddcctl/archive/refs/tags/v1.tar.gz"
  sha256 "1b6eddd0bc20594d55d58832f2d2419ee899e74ffc79c389dcdac55617aebb90"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0377e06b8510577260ae7a490fd2dc63ca9477a43384559cc454409ac9c89dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0badc9ed3ff51d2791d383be14e194131ad46573340e4c6bd2723207c624482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6572e1da056641ec5b483f2b5a77eb188753ccb3c9001936733c8c6ceb9ae8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ff8d31bf1287d9bf29c3f47b6fdc3034c3fe3eb801619cf2ca948ef69bcebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1650674a1529617dccc1fb61904f9586b17f9f61a63dbd740598019b1c6f25f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "909d9e837d2acb1d41ecf63535e1b352b825a17f3ff82a217bb45e79aff4b364"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8365113eb8f035269bdd0b58913d39ceaf9e6fbe4f9b0412b2b3bb1c5f7b20a"
    sha256 cellar: :any_skip_relocation, ventura:        "eaaacf4646080a84a4b1b958a7bb8bfc959a1b4e13718a0957cd9f65e6ed7b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8fd10cd210b815094fe4cdb168e6f63fdfe3320f559ce115fcdc490ea27f72"
    sha256 cellar: :any_skip_relocation, big_sur:        "3576d7627c47fd48bbc6abb8c200547cae4b0f074c11116f612c771c6172942b"
    sha256 cellar: :any_skip_relocation, catalina:       "eb787a2b87a3c356933abf84b5f4de0050534ae6112ad4a38ed057df3d9fc73a"
  end

  depends_on :macos

  def install
    bin.mkpath
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    output = shell_output("#{bin}/ddcctl -d 100 -b 100", 1)
    assert_match(/found \d external display/, output)
  end
end
