class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.tar.gz"
  sha256 "36689f98b0bbb9e227cf80daa802739c77e5f8a2cc2690fdcffb3c8598a4aa95"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f37777f765a3050a33af4a010a5c9ce230d2fc1146a3c0a7b4989746d6ea000" => :catalina
    sha256 "42732588b23941ca5dc67ae2fcb883ffe3c00e9e0a9d028e34e861f14cbfb3f3" => :mojave
    sha256 "93e821f843ab23c673002a4f368666430b80a3f844df0e1a7a33a02aca521836" => :high_sierra
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
