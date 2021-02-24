class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.25.1.tar.gz"
  sha256 "4de157c0997a12d9161bc0c10cb65053349325f2da9005bd271361a2bee8074b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28bb28f88b8f927784d215dcbe628f18c2d672ee6a72a017cf679ac9d86a0d62"
    sha256 cellar: :any_skip_relocation, big_sur:       "1650aad3eef08ca4899bce827ff02e61eae7f849a43f649463535381f6bd6296"
    sha256 cellar: :any_skip_relocation, catalina:      "b98cc66b38322984f4758f9656dd98f47d64a6bfd1398a5cc4010feeec88d82a"
    sha256 cellar: :any_skip_relocation, mojave:        "fc39f0a33db2c9152b0d5c1cebcb98959da6c1499af487b4107c4b801a870b84"
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
