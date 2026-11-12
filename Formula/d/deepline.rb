class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.500.tgz"
  sha256 "f453267103d4831580da960c970f434e1418831c489900d5c20a78574c47f7b9"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a21af8837ce74165efbc39e5b797989962e8282a267acd13f94d616e7edd8b57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a21af8837ce74165efbc39e5b797989962e8282a267acd13f94d616e7edd8b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a21af8837ce74165efbc39e5b797989962e8282a267acd13f94d616e7edd8b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e163e23e1d6d089b238f87dbb3ad7f5929826659d74da459736d765b9818c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f3d2dc7426cf6c3b835af14d66d0b9f3e5111aec123284811ca64bf718bd400f"
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
