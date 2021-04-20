class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.28.1.tar.gz"
  sha256 "56daf4fd751f5ce5703974aa2f0d6c4b77f20225c9ed639a61633033c87704c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d8e772f272f51cf10e4b38e2efa353fcbfbe8b559fd4e7c2f75ad9c3649c9cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "5668e4220a3c02a5adc34b5a04025f713ada3bb8a6abc985360f1a196230201b"
    sha256 cellar: :any_skip_relocation, catalina:      "296d79773030099ec042c35b405fc27e9f67f0a63b2346d6f46c271d6a29bd1e"
    sha256 cellar: :any_skip_relocation, mojave:        "3c39c6b89ade67632f15bb54e4c6fd2d9cecba88b1f6b3186d4811d20c400bc1"
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
