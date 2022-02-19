class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.33.tar.gz"
  sha256 "ff7ab429ecd54f6e2aedcfd4835eb8ca17c1990aac2534f8c2a19ce4267ade24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ea4c4124017e88b87e0dfc2051a7bd49255fe17e496ad4275ed1b83d0a686d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583e00e6fdf39984e6954354a5561f49811b10afa4390c5bdf6e066c716f2b51"
    sha256 cellar: :any_skip_relocation, monterey:       "e81d93294d8e24c93de4edce9a1f447d9d54a10c9195ad85c72250ba369f3d04"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f5214c8ade401bd185a4446566680f01074b53471ed21aaae0073cb20a48ea4"
    sha256 cellar: :any_skip_relocation, catalina:       "73b3b2febcf5d854ef8fc140728378e7f25aa993dc5098a09b48602056f576ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a2f1a4c2f26e19af15347d0a94c9208c9518a9d9740b8774047a2377168c9a"
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
