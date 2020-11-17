require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.25.0.tgz"
  sha256 "f3a849acf2915b60e12622688c2fdcc10ad7162fad61e5df415676460c3592a3"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "23a07fc56387e9b9c4775cc5a019c7a84aac92014a16c6b4eaf0fb632513be08" => :catalina
    sha256 "8195ff1e2483e2e5ffeda4a803f83a0a317182a35f1d5044883155e99d95d27d" => :mojave
    sha256 "f4f231c624ab61391ed89cd171b55fe3938000c36b3155f5e58c7cb67ca66526" => :high_sierra
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
