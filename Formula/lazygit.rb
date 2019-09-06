class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.8.1.tar.gz"
  sha256 "274ba05573b38cccc56cb63053eec0972535979b95f1f30b6ca318d991f2c14c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c496b0eb15a8125667fa0a3c894825c3f7bd15153bf6d73c2396cad5e6af0346" => :mojave
    sha256 "347b4d71a314a38e4574ca61c3014d0cb037e93f413df07c80cfce289f577ee4" => :high_sierra
    sha256 "216fece43e1dc34031bfd2bed23fcb26b9a62e8052ff961295d1823ed5062559" => :sierra
  end

  depends_on "go" => :build

  # adapted from https://kevin.burke.dev/kevin/install-homebrew-go/
  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/jesseduffield/lazygit"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/jesseduffield/lazygit
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-ldflags", "-X main.version=0.8 -X main.buildSource=homebrew", "-o", bin/"lazygit", "."
    end
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
