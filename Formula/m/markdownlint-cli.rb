require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.38.0.tgz"
  sha256 "2c8d61cbdf9d86b4f3eb5ac56ee231bc5aebd9c96a8f15c32354f363e0b2bebc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22eb556c507aad95dbb710328a9026acab0a425e74c000bbaf9ddd1447236a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e22eb556c507aad95dbb710328a9026acab0a425e74c000bbaf9ddd1447236a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22eb556c507aad95dbb710328a9026acab0a425e74c000bbaf9ddd1447236a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "851cf4c999f86744624e97afac9f10d628ecfd3bd633da78345c594e19b30762"
    sha256 cellar: :any_skip_relocation, ventura:        "851cf4c999f86744624e97afac9f10d628ecfd3bd633da78345c594e19b30762"
    sha256 cellar: :any_skip_relocation, monterey:       "851cf4c999f86744624e97afac9f10d628ecfd3bd633da78345c594e19b30762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22eb556c507aad95dbb710328a9026acab0a425e74c000bbaf9ddd1447236a5"
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
