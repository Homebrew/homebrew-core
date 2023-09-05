require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.36.0.tgz"
  sha256 "13e89581cfc7b49613ff716e07d16b486af2075ac518c03d3fc45e4080961d9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65d645bc14ddafa08c0c1057c87f123602a039cd2dca2e4a6df8878f9de29e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d645bc14ddafa08c0c1057c87f123602a039cd2dca2e4a6df8878f9de29e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d645bc14ddafa08c0c1057c87f123602a039cd2dca2e4a6df8878f9de29e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "ac0408c7b4f59bb3d2f07a398678d75f44661c4110691db27115910c929500a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0408c7b4f59bb3d2f07a398678d75f44661c4110691db27115910c929500a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac0408c7b4f59bb3d2f07a398678d75f44661c4110691db27115910c929500a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d645bc14ddafa08c0c1057c87f123602a039cd2dca2e4a6df8878f9de29e0a"
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
    assert_match "MD022/blanks-around-headings/blanks-around-headers",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
