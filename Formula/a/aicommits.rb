class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-3.2.0.tgz"
  sha256 "d477fe3aafce4b1639100e4661aae1e3703a55fea019df060c332879d6bf1a8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e463f762645f6651bd822de7f5a987caec027b8608e3c8e36fd90861e86cfc85"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits 2>&1", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "No configuration found.", shell_output("#{bin}/aicommits 2>&1", 1)
  end
end
