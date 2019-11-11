class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.10.3.tar.gz"
  sha256 "37845a7385b1f7519b62906ac727bfffaf0684fdebfe8c29d0dc034c1ecfbb69"

  bottle do
    cellar :any_skip_relocation
    sha256 "b933b6d1c6cba65f67b283c0dd7a3a941b8be6c7c65a4aa161c5c8d5a6c42352" => :catalina
    sha256 "e21b5a5048066a9a97c978a10013ce31d830dca0f6baafe8fe91f779c0d838e4" => :mojave
    sha256 "15d1526c0d91c1b20025df33dcf9db9678e4005f4ca2947c79bd3cf41439f088" => :high_sierra
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
