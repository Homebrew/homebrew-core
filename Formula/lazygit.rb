class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.9.tar.gz"
  sha256 "d0d8e0d86384bbdfc6f354f740b5396d48ca639c6c63b1d0c65cd70048fdb598"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6e06214b667e24b08d15a269836cafcac7e32450fd970f4456e8de15f676429" => :catalina
    sha256 "95e5a759fcffb76ed959f39581e6bb43e9831b50ffce45c028220eec5c98744a" => :mojave
    sha256 "e53ce88ff9e2b51ac874dd48245a7ffd75b42b1e5c7fd45f5117ec0cab82c641" => :high_sierra
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
