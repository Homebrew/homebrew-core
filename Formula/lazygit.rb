class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.25.1.tar.gz"
  sha256 "4de157c0997a12d9161bc0c10cb65053349325f2da9005bd271361a2bee8074b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbeb8208a05a34d7564fad0a3b32d47bb3542c70a76a14468382d2d5ab37de82"
    sha256 cellar: :any_skip_relocation, big_sur:       "4262367541a146535f18926dd3583a58d83956575c0a5b9764904d72a3ffe77f"
    sha256 cellar: :any_skip_relocation, catalina:      "98a999bd08c3f2bfd8054402eec145af28aef4a884782845477e9917e8d818cf"
    sha256 cellar: :any_skip_relocation, mojave:        "e683e5608d824870c5b6aa1dc72c6dea7d3e46a477ce438f96fc9017cec8c51c"
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
