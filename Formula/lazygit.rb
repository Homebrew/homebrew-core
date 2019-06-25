class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.8.1.tar.gz"
  sha256 "274ba05573b38cccc56cb63053eec0972535979b95f1f30b6ca318d991f2c14c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad5d02d822e18e226260af3de49be20ea98db37591dc86ca68e9b8162e57a74c" => :mojave
    sha256 "39f3737245039791b47d17f97e7ce57457bfcf061ac13a7f382c233e148dd4a9" => :high_sierra
    sha256 "5af8f89481e865a7d50e0315448707943fc8abcef3f2a49db9f7b5e6942a6be5" => :sierra
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
