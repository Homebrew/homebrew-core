class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.24.tgz"
  sha256 "cd6a68a665c15916f4bb507b361d08ea4a0967821e0a9d594229d4009a4b034b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abdd4ec57ffe64f337ec5897dcead36bec152cd373ebb5bb93a97363e47f03c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46583016cc2e75ea9351f90aee571d163ca31f3ac9e2c930fbaf10607bd70778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46583016cc2e75ea9351f90aee571d163ca31f3ac9e2c930fbaf10607bd70778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "46583016cc2e75ea9351f90aee571d163ca31f3ac9e2c930fbaf10607bd70778"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8dd7d0d4ebe5513098e0410f276c4e9fdfc1ae1f1b74473c5acca599743551ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8dd7d0d4ebe5513098e0410f276c4e9fdfc1ae1f1b74473c5acca599743551ee"
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
