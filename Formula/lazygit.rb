class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.8.2.tar.gz"
  sha256 "aaaa4cb789d387a08eb46ca95159561cdb4a2f4e70315ce68ed61bbd30fe24ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "c496b0eb15a8125667fa0a3c894825c3f7bd15153bf6d73c2396cad5e6af0346" => :mojave
    sha256 "347b4d71a314a38e4574ca61c3014d0cb037e93f413df07c80cfce289f577ee4" => :high_sierra
    sha256 "216fece43e1dc34031bfd2bed23fcb26b9a62e8052ff961295d1823ed5062559" => :sierra
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
