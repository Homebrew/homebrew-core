class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/v1.3.1.tar.gz"
  sha256 "c37cedf52b3ea267b7d3de67dde31adad4d2a22a7780950d6ca2da64a8b0341b"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6779e8aac5ff5f0030415d13df0b1ae2bf6349683ad6926b63d1b5c17e516bac" => :big_sur
    sha256 "367a0e8d166a30749447132c88d5bf1c43fc8ab7c4316c91a990c13d4e887c32" => :catalina
    sha256 "b61330cf67d4b8a572bb2f7a22434a00bb74d85bb93254ff6a60e8d3c8f12877" => :mojave
    sha256 "95786772c28deeaaa6c979f93174e1f49bd6dd8370e8927861f6b950dd5b3910" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "git-hooks", because: "both install `git-hooks` binaries"

  def install
    system "go", "build", *std_go_args, "-o", "#{bin}/git-hooks"
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
