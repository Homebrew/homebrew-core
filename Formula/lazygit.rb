class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.29.tar.gz"
  sha256 "f25de2ddab99d2ea06aae87e0be6365033b2ceb8efe94807c8b074884d5e8e38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe9009947634d445ec40c64c8c1731295d9bcd4bd347f3f783521288bf095f14"
    sha256 cellar: :any_skip_relocation, big_sur:       "5963d0016f48122e456cd903be82fc706329f9d03a8e23894eae17c3915a39d8"
    sha256 cellar: :any_skip_relocation, catalina:      "772c417d2ace262dcaf3ce94104dcb5517c53b36765197907b27878bafa202af"
    sha256 cellar: :any_skip_relocation, mojave:        "7a04428d1253c4df7522a10e8f0e86fe0ac085d563cd0f507d25539b753ad452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a9e4cdc6262e4692d23e6f0a5df9e38368a2473902f637feb4cb5aa61f5612"
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
