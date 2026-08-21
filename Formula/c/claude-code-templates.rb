class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.29.4.tgz"
  sha256 "b5c67ea73eebb3bf6aee21556182d7aba4d58d12ac49acc5c98d351071a6babf"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "21fa832624394d5cca6f0bc83714bd840bc2d21384ac821a7dafc563e9adc04d"
    sha256               arm64_sequoia: "006a68414ae23a7b1c19e2912fadd9e545461d689083f632fb894b1f968d3890"
    sha256               arm64_sonoma:  "331500782df4e9d52c247203e3116b827b168b6a9f0fa6e6a261d944dea83d4b"
    sha256               sonoma:        "92131234fc34d90755e05b30e7dcb719a8a68bf191687dd3467987369664b54a"
    sha256 cellar: :any, arm64_linux:   "172dfe26ca2325001fdaa7790b108c162a716973ecf92e2ab211969fe462782f"
    sha256 cellar: :any, x86_64_linux:  "b192b9f4f21b1e60d0ee6a086123df873125c6eaf968b7cb9d5e68e238f84d45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries which were source-built via script
    rm_r libexec/"lib/node_modules/claude-code-templates/node_modules/bufferutil/prebuilds"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
