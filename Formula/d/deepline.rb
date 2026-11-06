class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.472.tgz"
  sha256 "41aa4b354b29f166ddfd23226df72cb5170722e3971d044cfa412dd223b461d4"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6905cafcc2e2ec40d8f473f4f61e2c735e72bae8d098effbcd2f2a0b8197de8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6905cafcc2e2ec40d8f473f4f61e2c735e72bae8d098effbcd2f2a0b8197de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6905cafcc2e2ec40d8f473f4f61e2c735e72bae8d098effbcd2f2a0b8197de8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "983ea0a1779ead795cc92185331dd8a5bfc1dc6229ee697c15f54df586d6bc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a26d48d52e304d09cf648ffa0a7b48a6f4eab15313badcfe540d8b3c504f0ad3"
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
