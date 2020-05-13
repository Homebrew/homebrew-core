class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.3.tar.gz"
  sha256 "974526d882976970952c14ad17275681f678785648064e7c465b7d2b671d4f35"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6baa431a7322edcd2e86fc1bf46dc997e8f38bd0dc8df3606dcb5c4fe2d44c6" => :catalina
    sha256 "d8407f137d9c04b9c9d963ff161eb3d4433960eb1a7651656f9bf28556bfd5ec" => :mojave
    sha256 "c3818245476994213fcd40ffc2f492a251f947d29d94c589455bc4f546a11d9c" => :high_sierra
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
