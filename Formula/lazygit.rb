class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.10.4.tar.gz"
  sha256 "87e64b5bcb03aac2d518f20893169831321f05964a1170c5933935b157ae8471"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bbcd0539b4f341c5939874d2543094e8d2f87a33dacce3dce07fa9bd8ae679a" => :catalina
    sha256 "a1593d3df8c4b4867ae40b538e6613b76b810fd6186f30a69377901f901ee61f" => :mojave
    sha256 "cd610dc035c54e289935668ba701f500829c56db9b87472ee5422737462a5fdc" => :high_sierra
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
