class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.491.tgz"
  sha256 "d2b1b68a3118e9747c295c45dd6671a1cda93eeab58aedce1bf470a6209a9833"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "941669a4f5767c6e79e504238646d431991d57b07b7e040aab6ea61198cc8b41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "941669a4f5767c6e79e504238646d431991d57b07b7e040aab6ea61198cc8b41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "941669a4f5767c6e79e504238646d431991d57b07b7e040aab6ea61198cc8b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18a0fbbb46a7241559a929949a4f15a060791761e864a048c9e16f4a049add1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "02960dea602fe3b78203c357e3ee9f5a34bc987743a960405901cb61f1276b79"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder --json")
  end
end
