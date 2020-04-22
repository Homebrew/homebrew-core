class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.2.tar.gz"
  sha256 "ee99f77ae67129764835e6d85afd71a4f91c61a06952a891fe8fb46d8d5425e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "84939c6cfb774d105b6b84aee0b96ae9e50fcdabc16f297d3e51bac9640f90c6" => :catalina
    sha256 "fa3dba81478e8a5894aed6bef6c718abaa62bf194c87175946baa1fe4766458b" => :mojave
    sha256 "9f4b6919bc683754c58b100807f49c01f7f72254d0335b5d17e40dcf0becb213" => :high_sierra
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
