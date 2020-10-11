class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.23.2.tar.gz"
  sha256 "a541756a28d00ffc1fc9ba385c06b91fcc51df815a2919f7072873c969b2034c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f9541e1e0377f36c1dce67c14efdf49897280477882fe1a4c372502a1869a45" => :catalina
    sha256 "b0908cbc35d6b50c863d09db9f50bd5c33d7b27d96da2a3142af83ab5a60333b" => :mojave
    sha256 "5e6b0fe001e73dfa79a7a6a76b9cae2f8fafdb23ffddd28ac59a939dfa4c22d5" => :high_sierra
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
