class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.17.1.tar.gz"
  sha256 "5afe88abb84b80956e24ffbc60819a9ecf5bf80a1fbf06238abd049d9e3c4682"

  bottle do
    cellar :any_skip_relocation
    sha256 "4acb9a22ab610b70eeac15aa8bfbde6d7abdd696a5475ad887ed1dac0f0e55e5" => :catalina
    sha256 "89ec9d802e2b6295a854578ca1c82e580b8a1ecd705d0136686fcb7d0e0d5453" => :mojave
    sha256 "31b8c0c4d902b2dc5232e6ca306a52f59aaee551768df219e98b805541602798" => :high_sierra
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
