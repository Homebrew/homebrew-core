class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.8.0.tgz"
  sha256 "3198b937055bb07acff469818a6366f61bd461a03a3ce01bc1ce1d9d1c5a6a7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ef8eabddb382dc31438075147b39fe45bf32702b717a034bd0dd6f7eba78873"
    sha256 cellar: :any, arm64_tahoe:       "0ef8eabddb382dc31438075147b39fe45bf32702b717a034bd0dd6f7eba78873"
    sha256 cellar: :any, arm64_sequoia:     "0ef8eabddb382dc31438075147b39fe45bf32702b717a034bd0dd6f7eba78873"
    sha256 cellar: :any, arm64_linux:       "d6cb695d30275f010a0089a5dd6d41625f15dbb652b458b4a9f952701d0ecf87"
    sha256 cellar: :any, x86_64_linux:      "1af804b5c00eb6da3a9c7cfee73d0e3e072ad429ff7ea6a50090fb9202c0c672"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
