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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a87fa6a528edb5ca8da660bd728548bba5b38494f492abf4d2938bb99fa5676"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a87fa6a528edb5ca8da660bd728548bba5b38494f492abf4d2938bb99fa5676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a87fa6a528edb5ca8da660bd728548bba5b38494f492abf4d2938bb99fa5676"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d7baa582f7ad9e7d3d6d0715a8a6191165a439462072daa4a361a45fbf90ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55646999be9a2e43b52ab73c7301f809ac033e52a8666515c7f2a29114f7009a"
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
