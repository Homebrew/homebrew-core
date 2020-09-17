class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.22.7.tar.gz"
  sha256 "712228f82e4e80f72f4437037c3dbfbf1d83a4f1ee7b8205f741175c4d00c60a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac91209b340345cc958da7da0a5fe10fcf258c8cc6c0896280ef835874717fe2" => :catalina
    sha256 "081bbe566545d3898f4489629ca2dec991f5e64af267cf4888249bf0c6bf87aa" => :mojave
    sha256 "8b9482d272dd229c82dc101c27792da4ac2537d645b9be7cd7d7f325bd7d86dc" => :high_sierra
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
