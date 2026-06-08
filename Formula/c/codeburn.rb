class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://github.com/getagentseal/codeburn"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.11.tgz"
  sha256 "8cd18a0fe41708273ee62e6698c50f2997149c57edb0869ac04945c6a5028c7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b1e48f74848c91666b4c41856893b4dfc3e8c386665a027b4f88e18fb73efb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b1e48f74848c91666b4c41856893b4dfc3e8c386665a027b4f88e18fb73efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b1e48f74848c91666b4c41856893b4dfc3e8c386665a027b4f88e18fb73efb"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e49755f65020f18d6c0f8f0f35058b6e30a11c43c5f584250549e3a4a4c630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e49755f65020f18d6c0f8f0f35058b6e30a11c43c5f584250549e3a4a4c630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e49755f65020f18d6c0f8f0f35058b6e30a11c43c5f584250549e3a4a4c630"
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
