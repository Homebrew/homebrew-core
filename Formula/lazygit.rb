class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.15.7.tar.gz"
  sha256 "dbec001beb1b1b382cfc0d30a1d6c38bd9fa88cd7aa7aebaaeebe592b4ed487d"

  bottle do
    cellar :any_skip_relocation
    sha256 "091a621e513d40496c0ed9d8c261c404a2ddd991fc9593d188037964648de8c9" => :catalina
    sha256 "fa3f83accb1f26a1dd59da3aa9964b71c1489547e9f33d09cc0fccee260076bd" => :mojave
    sha256 "70f4b6a4a989246986ba714bd59dcd4a814aeca477e9166af61449cc3725c3f5" => :high_sierra
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
