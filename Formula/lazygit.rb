class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.31.3.tar.gz"
  sha256 "7a9fcb0c5f1edf025d1e1f5fb21099770e0de7ed424af62e133bd9d4afffdc35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e1ea5dbda063c0c1cd73f89d69edb5ad7eca21b10d3f6a84936212fe0ae363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87e4aa569196383fb022e4085669c35fcab323486d0b9a48f42fbe2657f715a"
    sha256 cellar: :any_skip_relocation, monterey:       "0e938f2c2db10aaf3dc6521b4c1458db34b8f40dc29400b8c6bfb6b6d3fc9479"
    sha256 cellar: :any_skip_relocation, big_sur:        "0193f2e973f9c6a49f484167f9fcdeea1aaaf6f37b9bf783d8a47dd481e8a00b"
    sha256 cellar: :any_skip_relocation, catalina:       "66f40232273c5876f899c1beb8b2bd5d4ff9a12e49a4cf4e3c200ab422dda817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636767a737774eae2db68f67ed0be16f82758efe9c1f917b5a268b804d7c959a"
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
