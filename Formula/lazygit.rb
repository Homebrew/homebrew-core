class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.34.tar.gz"
  sha256 "f715ab86b219fd42462399459bfa1e04a5925268bff4839c4d96bd01264d6847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77c0725d4dae58f89a0f97b40f4bd7db99b0895d330e2fe3cacfb9a66e485b71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbb1adc9a754bb656707cd43fe0a941599a79c449d4f23530857a74a346c3b87"
    sha256 cellar: :any_skip_relocation, monterey:       "2992aa17a82fc5d61910732b69a2f5632f54dde5df6d7a577a2456a66c863340"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf4376ea6950a82e9d1dd41849d58fa1f228d3e9bc2c37e7f09ae6a532481f86"
    sha256 cellar: :any_skip_relocation, catalina:       "a2feb23f65422d7f94c5a47363ad9338c729d49fc29e30d2170314c2327d8290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7545e46900a94c0677bf159776dee2812e12a4c2d2349f87647e4677e2b3112"
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
