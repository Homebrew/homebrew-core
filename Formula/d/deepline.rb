class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.529.tgz"
  sha256 "cc3e627f651446c97bf7b247df2698b71a23d1623baed1331e7df10f85ac3c25"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20fa6970a90a5de55f4f59677ddcb0fb97502d0b69c89691aadb8ad1af4a0a99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20fa6970a90a5de55f4f59677ddcb0fb97502d0b69c89691aadb8ad1af4a0a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20fa6970a90a5de55f4f59677ddcb0fb97502d0b69c89691aadb8ad1af4a0a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51ec77dcfbedf0d02e5c25313caeb2aed6d70bab526c9b7c090f0485335496aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a3f5149f450267f1674c0ee3e711beaea3719141b869fc2f01c13e5bbff2a317"
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
