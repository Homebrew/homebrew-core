class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.32.2.tar.gz"
  sha256 "44a735c4ee78838dc918e82bd5070b154600cd24992259fd698f2116a797012b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb4c5f2e96817acaac93fe2f79915d63208d86449de87868b48f0fc507d89610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204606cf46b4a399a04a14d6d8b28a5fac83ee7a734e9f1e955cd68323b30507"
    sha256 cellar: :any_skip_relocation, monterey:       "8cac4d29e3f6a8515a9e296479c229d7b8a4c3db56b09d2f8f7d14a5f7067f16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f048401c04b64c55e52b9e728a6f283488ebf339ce4eb20b5d2e58048343d2a0"
    sha256 cellar: :any_skip_relocation, catalina:       "88c896f73452c8d784279440251d5a75b5132b769d529de2dc0ce0aa6eed0f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c56773aeac4615cb0d322c40eec9ab7ac7e37fe53baf8dd4ceee84ef368323"
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
