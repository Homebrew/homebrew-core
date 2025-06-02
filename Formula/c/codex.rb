class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505291658.tgz"
  sha256 "066a11322e815d680799330cf360bc9601deb0a40d907546c2cda9eb22cca86a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, ventura:       "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    libexec.glob("lib/node_modules/@openai/codex/bin/*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}/codex --version")
  end
end
