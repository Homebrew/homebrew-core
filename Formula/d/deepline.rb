class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.484.tgz"
  sha256 "f0f6fc6fcebed5fff4c63a593b9dc70994e421a875b89269671e5317a886a3b7"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78beea7a6f04921d18a6fd75bc6949db1b970ab2535e3f1c6f3c8773f5523238"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78beea7a6f04921d18a6fd75bc6949db1b970ab2535e3f1c6f3c8773f5523238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78beea7a6f04921d18a6fd75bc6949db1b970ab2535e3f1c6f3c8773f5523238"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f55a93d7875326c00603a62037fc7393578d02701aac162b2ac2f645d0e7c121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de11f3183dbe74fd3b78c7431eb19e79f2a8944fd7a037af764042c28c4206e9"
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
