class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.26.1.tar.gz"
  sha256 "7bfda18345993206d4d388ea0370e9b54af0354d37f4a64803461889b361d547"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb336f6391ea94b30b602354e1d206a33baac54d6f65f0ca6240f61f2a7ac5f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1a75fa3fa6b6964cba0e182726f71d4da13f397edc310a262f21cc8e6b2f97a"
    sha256 cellar: :any_skip_relocation, catalina:      "a4b12ca3cfd22224759328448b1932732690c1a63592e407cb3d40ba71ac0fbf"
    sha256 cellar: :any_skip_relocation, mojave:        "65ff729f7852eeef15759ffe1b30406e34aa28e913949e6e8ab87b1fe95cad50"
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
