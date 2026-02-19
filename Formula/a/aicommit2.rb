class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.4.24.tgz"
  sha256 "0fe23aff20951184983878e5fb511e6c2b5f35685869ce6fb228bd904d3dc438"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9a958e9f47330f813abd867027720a2b2d856493ff145021af8227079f3b558"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aicommit2 --version")
    assert_match version.to_s, shell_output("#{bin}/aic2 --version")

    assert_match "Not in a Git repository", shell_output("#{bin}/aicommit2 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found", shell_output("#{bin}/aicommit2 2>&1", 1)

    (testpath/"test.txt").write "test content"
    system "git", "add", "test.txt"

    assert_match "Please set at least one API key", shell_output("#{bin}/aicommit2 2>&1", 1)
    shell_output("#{bin}/aicommit2 config set OPENAI.key=sk-test")
    assert_match "key: 'sk-test'", shell_output("#{bin}/aicommit2 config get OPENAI")
  end
end
