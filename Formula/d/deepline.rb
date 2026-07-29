class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.307.tgz"
  sha256 "dfe8cd31cc4e124061b566cebffa280a2d6804b40a56332add860a2be3b88716"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25989410e98bf6b970c2a9418f6f1d3bd8cbc13f00b6bb6fe1b5bf9dd799cbb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25989410e98bf6b970c2a9418f6f1d3bd8cbc13f00b6bb6fe1b5bf9dd799cbb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25989410e98bf6b970c2a9418f6f1d3bd8cbc13f00b6bb6fe1b5bf9dd799cbb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf342d0fa55e6879ab5feace8978f32cbe1dede4a4fea5bbc66b8bd439e5635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f73517531eb365374da877691cf0ac82c5c9214dcbb6d6a87ddb2274f86e3ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e388d37944bbebce6cc671944a256f2182b77eba7bdc9b137757a708ae390c88"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
