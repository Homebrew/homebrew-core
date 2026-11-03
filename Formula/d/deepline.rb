class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.461.tgz"
  sha256 "5ff69276006c6c4eeeffe14557ffd53ee57b6e96f0bb4d2166e3855858fef22f"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e39c505aeb780df68409915e4356f479e457f86154286a7d3a0babb9b94e3fe9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e39c505aeb780df68409915e4356f479e457f86154286a7d3a0babb9b94e3fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e39c505aeb780df68409915e4356f479e457f86154286a7d3a0babb9b94e3fe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49c540f1a19e573098ae81120167dcb93d7a1d6a99e2c1b3d1eb1cc078e7191e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "99906c2d8abe1d02f66ceda215d07c73bdecc69cacb635282f06a01c5659ef20"
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
