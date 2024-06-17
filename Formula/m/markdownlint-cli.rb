require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.41.0.tgz"
  sha256 "1014bdf5901d5e41388722547bb64d596a8d456f08699f61e32ed6d22476f213"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4223ddc7b2e85d0027703f10d512859da1f4626b29576619cdc8b58399adf1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ae6b3c6ae09c48a801363861286b53fc1859074cbf53bfc6329d9d2d140515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8fa05160f755efe6823f762f839712d4105667f747afa2f41344e29725809b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0c94e832066c476473475a1f6f421643387d48ad3fcc9e169a3ee46164c1871"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5f743be301c321b031f8a3eebc21b7abdb7e9d83b49616e23d462625170cce"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b372b27888b67c9f1501980d99b4c4ab289129aad441238214cf268bda24e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9791a220e0753ce7d9d778ea5013d61903b297761f947c4e8812841afd947431"
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
