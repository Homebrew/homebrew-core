class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.12.3.tar.gz"
  sha256 "0338c29be43ab1393ed9dfcda20a93c44f40753c26c8e516b6ed7f79f7275ec4"

  bottle do
    cellar :any_skip_relocation
    sha256 "95f5a69111a7bd3cc59302bdf298558be833a45f4586f94770c1e1505275fa33" => :catalina
    sha256 "742b61d507cc26dd2164fbd79a4fdb29fce9bfbcda93fa4e3b2486cb5592a9ab" => :mojave
    sha256 "2f64cf57b5fb8b40f798de7b4057c208aa20caec8a1a31b7ddf9ec4dfa59d1ab" => :high_sierra
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
