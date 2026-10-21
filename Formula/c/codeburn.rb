class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.27.tgz"
  sha256 "03e90a178821865af474a5511a985de1c53e63799ffafa34e76f0d8dd58911f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0468be00d84fed3bfb4b6f6f926cdcb8c7bf4975f3322235a6c65c37af039d20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0468be00d84fed3bfb4b6f6f926cdcb8c7bf4975f3322235a6c65c37af039d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0468be00d84fed3bfb4b6f6f926cdcb8c7bf4975f3322235a6c65c37af039d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63a68e52d78a905d63d0d7b44bc74a5a5c0d827ba4bedbb0ed61455df92e3499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "63a68e52d78a905d63d0d7b44bc74a5a5c0d827ba4bedbb0ed61455df92e3499"
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
