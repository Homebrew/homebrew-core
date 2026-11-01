class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.453.tgz"
  sha256 "34674599dc4dce2f393b55ba353f889fe94cf03381d58a342ddd4d89db6f1480"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73d25a557bd35d35c3679e99ae32552f309761f9ec0f006bc9e48e49597b26d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73d25a557bd35d35c3679e99ae32552f309761f9ec0f006bc9e48e49597b26d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73d25a557bd35d35c3679e99ae32552f309761f9ec0f006bc9e48e49597b26d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cca19148733e858a88279f89eff6fdc004843d5553c3b51a0fb481d278997d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2f86575e2e6c2e619e7fc537667477f82c83c57fbd301e7724ad5d201ed742b5"
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
