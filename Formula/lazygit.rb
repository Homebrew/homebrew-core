class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.11.2.tar.gz"
  sha256 "96a03b3e25b1b73e268ce2ce9fc63c11c43c67ba34d3901995c755fb932ab9cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "03811871128fad0491b67a8ab798faab81117930c8855bb00bf17a4d30f83f73" => :catalina
    sha256 "ca293a00b7618fb35daeef61126b64362687a79e06ab71f51aae582d0c3ac752" => :mojave
    sha256 "7674fbac857593e38d516deb8411b27a76df3a682d012d1c505ab37dacd08090" => :high_sierra
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
