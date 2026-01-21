class Phantom < Formula
  desc "CLI tool for seamless parallel development with Git worktrees"
  homepage "https://github.com/aku11i/phantom"
  url "https://registry.npmjs.org/@aku11i/phantom/-/phantom-5.0.0.tgz"
  sha256 "b097b6b6001479e06505cb317e439ed3a082ae5b07b874852c0ca27c4a553788"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95f621c48ef1e7062ff8350df36e7f5da2b068f07d0865acbd146c7b2810c690"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"phantom", "completion", shells: [:fish, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phantom --version")

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    (testpath/"README.md").write "homebrew-test"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    system bin/"phantom", "create", "test-worktree"

    assert_match(/\btest-worktree\b/, shell_output("#{bin}/phantom list"))

    worktree_path = testpath/".git/phantom/worktrees/test-worktree"
    assert_equal worktree_path.to_s, shell_output("#{bin}/phantom exec test-worktree pwd").chomp

    system bin/"phantom", "delete", "test-worktree"
    refute_match(/\btest-worktree\b/, shell_output("#{bin}/phantom list"))
  end
end
