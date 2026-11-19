class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.544.tgz"
  sha256 "5fa62c695cafe27a793030e56f31aacf4ac715969e3d753e51d0b52f22f98dd0"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9466cb69d012eb62f51d626b3a85f34102d23af2214833050bfcc53f61d6de2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9466cb69d012eb62f51d626b3a85f34102d23af2214833050bfcc53f61d6de2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9466cb69d012eb62f51d626b3a85f34102d23af2214833050bfcc53f61d6de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0917b30168512c04ef55e8018cc57f0d18c584f9498c9e090705b7f8dc36093a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "16a61426de2706f86c0ddb6335393bc8c0a31ccaa81ac903ae98d8c183d4ccad"
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
