class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.41.0.tgz"
  sha256 "1014bdf5901d5e41388722547bb64d596a8d456f08699f61e32ed6d22476f213"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c414c02b11e76ee418773ada20614178eafc99d22b4166565ab5acfa768360c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c414c02b11e76ee418773ada20614178eafc99d22b4166565ab5acfa768360c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c414c02b11e76ee418773ada20614178eafc99d22b4166565ab5acfa768360c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "131b5d2abb4e8b7c4f34a89ad9fea8c93b6becc15460b4709c4c3e35d2b1bf52"
    sha256 cellar: :any_skip_relocation, ventura:        "131b5d2abb4e8b7c4f34a89ad9fea8c93b6becc15460b4709c4c3e35d2b1bf52"
    sha256 cellar: :any_skip_relocation, monterey:       "131b5d2abb4e8b7c4f34a89ad9fea8c93b6becc15460b4709c4c3e35d2b1bf52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1b404f35203311f4a4bf0b444f488c2ecfa1886a4486e2930a99c8e14c1570"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
