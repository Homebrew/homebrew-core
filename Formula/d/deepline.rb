class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.475.tgz"
  sha256 "a9fa74e08b70616f03c31ed13414c3965f99c77f2f2cafc0059377601c7bb00e"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c182554733c8024650a6167716f8af13dda6773b4d2d3e321e994dbab69a1aa9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c182554733c8024650a6167716f8af13dda6773b4d2d3e321e994dbab69a1aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c182554733c8024650a6167716f8af13dda6773b4d2d3e321e994dbab69a1aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0c1bcfa9913be28b081a6b1d2ce4806e80dfddce100522adb6cbde091b9b8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6eb1db519d5bbf0ce5a4a409407a6d883a67040fb4ddc95f6c0e0d98c9ad915b"
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
