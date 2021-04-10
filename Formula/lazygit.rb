class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.27.3.tar.gz"
  sha256 "f8a1c0556db9cfe9098ca5ca8368d03c1b832157a61ab7efd937219fb8a41cea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57b612f1e76754ebcd459b1f8b477a621af82df9c14ee94cc792f091a83f3393"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d9cd26d2a1909de53a9afa6bc06c9277bf02181216f2476021f505d22262c16"
    sha256 cellar: :any_skip_relocation, catalina:      "e66dbef10c732cf088cb7a2b3038a8344fc1739f9b8cd550cad39eb3d9ee41d3"
    sha256 cellar: :any_skip_relocation, mojave:        "0e7420a3005699a711919c322e814b81afb57f81645ada5edcdd46fa932a1dd7"
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
