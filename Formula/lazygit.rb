class Lazygit < Formula
  desc "A simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.7.1.tar.gz"
  sha256 "00d584ff7285378d8d8cf83e98d0697e3ea9bdc15a1af5078061d27c5f5489f0"

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
      system "go", "build", "-o", bin/"lazygit", "."
    end
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    system "LAZYGIT_CLIENT_COMMAND=INTERACTIVE_REBASE LAZYGIT_REBASE_TODO=foo #{bin}/lazygit git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
