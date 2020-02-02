class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.14.tar.gz"
  sha256 "c63f699361c0cfc281bb8414350a47b74cea910f877785f7f3a63137812e985b"

  bottle do
    cellar :any_skip_relocation
    sha256 "699070257e59c29de565dd2d52575f4ce6d070ab70da15c8b27372e272185b48" => :catalina
    sha256 "2f8f6b7dfed488f297698dedce2630778551a198a7d5c48549382a707808fa7b" => :mojave
    sha256 "798209c28d1fbf6a990dc962fb3d9e63f9e7fbcfd2dff7cc2d006330e8b6e743" => :high_sierra
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
