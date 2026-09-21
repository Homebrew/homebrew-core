class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.100.tgz"
  sha256 "101d7220d6df1edfa0a3f48f80de16dfd087d112fe73ee1de3727e3d141ee52b"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5457fc9bdd91c00c523f0b4fea341d708a75993db909bce9f3a5a801fe92b8fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5457fc9bdd91c00c523f0b4fea341d708a75993db909bce9f3a5a801fe92b8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5457fc9bdd91c00c523f0b4fea341d708a75993db909bce9f3a5a801fe92b8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0781925f7d8581e931922b08210200934bc083959fb329a5d5e9fb00a2aa3864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "16520506c0b2577294ecf4549490562047805445d26ffd2108f809da9622f0e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
