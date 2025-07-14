class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.45.0.tgz"
  sha256 "8ce123a96b7a7f04f4dc684e9423f698fbf715c8f1fd17f2a2e1ce03f34d2a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81aac9f9af154d051df5deb42a3e8aacc9b454622355ff13abbd5e7c7200e43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81aac9f9af154d051df5deb42a3e8aacc9b454622355ff13abbd5e7c7200e43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81aac9f9af154d051df5deb42a3e8aacc9b454622355ff13abbd5e7c7200e43c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d466f9600586629cf57f503569f663be994a95b5ac0eda32b700f2bb17e2b1fc"
    sha256 cellar: :any_skip_relocation, ventura:       "d466f9600586629cf57f503569f663be994a95b5ac0eda32b700f2bb17e2b1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81aac9f9af154d051df5deb42a3e8aacc9b454622355ff13abbd5e7c7200e43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81aac9f9af154d051df5deb42a3e8aacc9b454622355ff13abbd5e7c7200e43c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
