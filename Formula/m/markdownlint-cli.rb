require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.37.0.tgz"
  sha256 "5c6ed9557e18e09ae7f014f619072bd413f0c87c6d20c8adc2cf7ff3f383c4d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f44ee2d353ff2ce3ced373a1749aec8564e31f686df68a5fd0703a8ce056c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c3844abd058474c9f9e8e2e3c252fdc591afd0ed80a3bf530a774ad2db4f8bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c3844abd058474c9f9e8e2e3c252fdc591afd0ed80a3bf530a774ad2db4f8bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3844abd058474c9f9e8e2e3c252fdc591afd0ed80a3bf530a774ad2db4f8bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c6997fbd749681b44a9bf337cbf2a6b174d2bb24a76456aafed62eb8008a71"
    sha256 cellar: :any_skip_relocation, ventura:        "ac7d8b351ea6a5772fe111190439803a3f2ddf2715ac4b9b00483987764e098a"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7d8b351ea6a5772fe111190439803a3f2ddf2715ac4b9b00483987764e098a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac7d8b351ea6a5772fe111190439803a3f2ddf2715ac4b9b00483987764e098a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3844abd058474c9f9e8e2e3c252fdc591afd0ed80a3bf530a774ad2db4f8bf"
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
