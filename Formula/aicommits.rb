require "language/node"

class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.5.1.tgz"
  sha256 "cc2d9011a3ef1eb7317078c9154753412f3cb42f8a73dccc1cd8f84744c57a72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "480ce28558d8bc194b9e22439c9fc314150f23a938bdc4b0fb18dba380ea67b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits", 1)

    system "git", "init"
    assert_match "No staged changes found. Make sure to stage your changes with `git add`.",
      shell_output("#{bin}/aicommits", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "Please set your OpenAI API key via `aicommits config set OPENAI_KEY=<your token>`",
      shell_output("#{bin}/aicommits", 1)
  end
end
