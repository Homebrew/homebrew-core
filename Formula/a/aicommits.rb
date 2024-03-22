require "language/node"

class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.11.0.tgz"
  sha256 "b74cf25eb31eb7098d01f482cd64a87e2f59d7efa11f5273fbb353f35e850c5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a500d7ca5f6978eb4e3bb96677f8f332267c5b3070aafb8f8c7b4af851435bc3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "Please set your OpenAI API key via `aicommits config set OPENAI_KEY=<your token>`",
      shell_output("#{bin}/aicommits", 1)
  end
end
