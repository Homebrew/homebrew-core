class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.11.0.tgz"
  sha256 "b74cf25eb31eb7098d01f482cd64a87e2f59d7efa11f5273fbb353f35e850c5d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a95d423b81063b3a9f2772969b4b627aacf2c173d841ab5cb6659c4224ecdf27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output(bin/"aicommits", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output(bin/"aicommits", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "Please set your OpenAI API key via `aicommits config set OPENAI_KEY=<your token>`",
      shell_output(bin/"aicommits", 1)
  end
end
