class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.28.tgz"
  sha256 "e4b0a41b70331c1e85b6fbbc4c7cb0dc75fb43de17790b51c737a42e034a6e2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c03b3291bc40ce1d7bf2c9961243ef1ea46149f64df25e3a3f3feb19698a9f4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c03b3291bc40ce1d7bf2c9961243ef1ea46149f64df25e3a3f3feb19698a9f4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c03b3291bc40ce1d7bf2c9961243ef1ea46149f64df25e3a3f3feb19698a9f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "958f58d7c823d72b774188bc0049f887260ab056ddd179403401d49aadcce26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "958f58d7c823d72b774188bc0049f887260ab056ddd179403401d49aadcce26a"
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
