class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.32.1.tar.gz"
  sha256 "58c8d21601ecdcdab47a127eb17cd4f2b71c40ec6d89eb98b3ccdeceef07aafd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4006257173d30a300898799861ec020375da2f2947d00e8e8e32f185fd6e9aef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b0a9660cbafacc06fe1d3cd0f73a1fbffadd49dfa070f7ee333c0d161e3ebe7"
    sha256 cellar: :any_skip_relocation, monterey:       "054253d8370c9a0e0e909899f8fb86b9b4ba85aef671023da24706200437b032"
    sha256 cellar: :any_skip_relocation, big_sur:        "61c5d1bde908f9a64adce6547afd462d8f080b1d9eb1da46be82cbcefea58360"
    sha256 cellar: :any_skip_relocation, catalina:       "1feea6f078587b4ac43023249bcec95ef7e6b0f7bd9162f2e24dec0a6d475d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "833c50eebb4ab92c8999037b0b79d8039eb0090ca4cbf658be5af2e5413979c6"
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
