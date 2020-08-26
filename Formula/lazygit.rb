class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.22.1.tar.gz"
  sha256 "ca2dbca39512e402cde22cd47eba3ff38cbbe4e12265aa0cb46b34277653b9bf"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccce236a36be0d02d20fd93c810ed38a2540bdad205c4f9450daad16e0d10435" => :catalina
    sha256 "3cad29414599d2132a9f84fa22e8012dec1bfbe43f323d82f0b23b6b183820ac" => :mojave
    sha256 "c6d9c77210dd7f0a3129dd1973b8306dc9dd405a4a11a94c6c338dd29178c5cc" => :high_sierra
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
