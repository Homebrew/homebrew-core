class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.23.1.tar.gz"
  sha256 "754a7751f609305fdbfc6630ec18cfd22f4b7b8e77ed9084e9e11a789a5788de"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "30cc908489fafbb8f046dbf1c71b0309ce27b31c571db6b7a77936e5af76c043" => :catalina
    sha256 "ec58a2e914f09753f5206a18ee39b2aff3f78e96c3d5508de834c52b776c26df" => :mojave
    sha256 "926c27a527bc8e9da6187a9a3cd56ab5da9f9936bbaf9cff42530161ca218667" => :high_sierra
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
