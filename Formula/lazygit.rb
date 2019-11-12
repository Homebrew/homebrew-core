class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.10.5.tar.gz"
  sha256 "ee94e54d7955b61b5049742a0f655a16ec29c06fcf7f1b5ec82410052289e5e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "32aca91d8967b0b14e96f69fd5adab5cb024f4fca95c28a4b860f1e86aa0943d" => :catalina
    sha256 "43441e336b06d63a79845bf1effce0fda6945c9c4b87575728909da1de05491a" => :mojave
    sha256 "153a10b18552251bec7880c555144f6a48f95dab506958e429f99affcc1586c3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
