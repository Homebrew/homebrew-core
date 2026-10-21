class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.320.tgz"
  sha256 "f682ab8737397a27080f3593ee9a063abf311c2460b186c139b529877007dc74"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e7992fd2f768b15988f8af0e0479eeb727099a8cdf091c82266d00bbfe814d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e7992fd2f768b15988f8af0e0479eeb727099a8cdf091c82266d00bbfe814d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e7992fd2f768b15988f8af0e0479eeb727099a8cdf091c82266d00bbfe814d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99d0bfc82bb5e7d3657a5a42b12828aea43b326018c8f441feac03f56b966677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d8ead7d1a5ebb4856bafa1e267a4556308292d3ff934693a6a65c4fd6457e388"
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
