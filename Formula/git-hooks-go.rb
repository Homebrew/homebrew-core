class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/v1.3.0.tar.gz"
  sha256 "518eadf3229d9db16d603290634af8ae66461ec021edf646e8bca49deee81850"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git"

  depends_on "go" => :build

  conflicts_with "git-hooks", :because => "both install `git-hooks` binaries"

  def install
    system "go", "build", *std_go_args, "-o", "#{bin}/git-hooks"
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
