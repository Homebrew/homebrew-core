class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.1.tgz"
  sha256 "7ac3713982bcf7af184c481c8ea2655a7384be16fa6926ab02c4147034657682"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dc01f142460db1ca18ebb3e125bbb89a9178240f8c63646a80fedd298c5af278"
    sha256                               arm64_sequoia: "dc01f142460db1ca18ebb3e125bbb89a9178240f8c63646a80fedd298c5af278"
    sha256                               arm64_sonoma:  "dc01f142460db1ca18ebb3e125bbb89a9178240f8c63646a80fedd298c5af278"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ee6e3aaed8a4c9f6f6348adb71a0d9b8a1ce52f67296092a162a4ccb3841e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7f6db3a53b4dfaeb1ccbdcd21f149bf697a7f32199a378149f0e544d2774323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c922ebfcdd52894a36fa61cc5856db90b5bd69cef270f0b87be91d459010857"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
