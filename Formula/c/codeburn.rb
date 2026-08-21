class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.20.tgz"
  sha256 "4416d3b074047dba22b909a34347dd0d388d06679c7ca6e4d2d98420bef21d1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b22a243b836921cca6fae4441b8ffaf7e8c9661df5616ce5669fb66b048d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b22a243b836921cca6fae4441b8ffaf7e8c9661df5616ce5669fb66b048d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2b22a243b836921cca6fae4441b8ffaf7e8c9661df5616ce5669fb66b048d2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c242a7119f6393e0cbe3b0a0892a85f42a0b1de3a0f6a9e8f89e02bc31d9e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c242a7119f6393e0cbe3b0a0892a85f42a0b1de3a0f6a9e8f89e02bc31d9e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c242a7119f6393e0cbe3b0a0892a85f42a0b1de3a0f6a9e8f89e02bc31d9e59"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
