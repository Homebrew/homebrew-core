class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.9.2.tgz"
  sha256 "1c4977b48315b0e58a17364ff5ce4b14661f66b534b4adca94213958c325f07a"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "c087b8fb3b7dfcc7df35e253f18fbb6c3f1701af227d796aa8fe4180f0d5b1fc"
    sha256 cellar: :any, arm64_golden_gate: "8a8fa301f3fab23f56344c19a1f71020648c24145c6f2f85847176df47c891bd"
    sha256 cellar: :any, arm64_tahoe:       "8a8fa301f3fab23f56344c19a1f71020648c24145c6f2f85847176df47c891bd"
    sha256 cellar: :any, arm64_sequoia:     "8a8fa301f3fab23f56344c19a1f71020648c24145c6f2f85847176df47c891bd"
    sha256 cellar: :any, arm64_linux:       "1d6a1c7290b4a540cb9b2b1900e6c3cd26f07b1bbb07b1e31ead3c5ad0a51937"
    sha256 cellar: :any, x86_64_linux:      "cc91f2bb7321a0b5705181b746b2b1ffdf757f2a962af3ff2320139ccc0e31cd"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath}/missing.png describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
