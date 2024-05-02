require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.40.0.tgz"
  sha256 "2919296cbdbce0de23dea9177d7da930db3b818026dbaa9f3f0d263c6675930a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a940bef0f51bb1ed0150943bc654ae24f9285bb5c5e98bca6669cebd80506e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a940bef0f51bb1ed0150943bc654ae24f9285bb5c5e98bca6669cebd80506e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a940bef0f51bb1ed0150943bc654ae24f9285bb5c5e98bca6669cebd80506e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f7767a0811719a2a97f8f51eaac58b2e1cdca470c91f94477c5215f1aaf42ed"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7767a0811719a2a97f8f51eaac58b2e1cdca470c91f94477c5215f1aaf42ed"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7767a0811719a2a97f8f51eaac58b2e1cdca470c91f94477c5215f1aaf42ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a940bef0f51bb1ed0150943bc654ae24f9285bb5c5e98bca6669cebd80506e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
