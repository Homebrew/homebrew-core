class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.34.tar.gz"
  sha256 "f715ab86b219fd42462399459bfa1e04a5925268bff4839c4d96bd01264d6847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30e0594de492a60ecad6821d9ff0e794492d55385c25148401ebca419af46af5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a96692dba5360beede40e67213a854d6138d44d5428bb2e1c3cfd1466086367"
    sha256 cellar: :any_skip_relocation, monterey:       "eef7437be5b2eff4affc4fe853401150f00eb9b1e95c7ee80663d2783c73d964"
    sha256 cellar: :any_skip_relocation, big_sur:        "d34e4548bdb917072eb93ffdda8cf340c02cc33bef44470adfa3368d61d387e4"
    sha256 cellar: :any_skip_relocation, catalina:       "5034e920ae689acb1a4d40d47b4da0965d536d671264184cc97218b96f85f412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da918aa07de01f2d91ba477f96d26b23adadb823c1f3d73f2fba7d9c629dde65"
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
