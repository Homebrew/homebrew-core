class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.4.tar.gz"
  sha256 "8af316bf9d0916e8b19ce590a80664314a38652af9ef115083686bc9720fa7b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1208b282f14c75a93a01f791009ea644e7438ea812e411fef6a8a47f63acbe5" => :catalina
    sha256 "2a8ca3c11245e60ea115b0e7c4a24c85724096e4146040ea88a4b679af8a4b07" => :mojave
    sha256 "fb0346d006b244733af581f5e249e643d8653cc1b1d9c42bec7e71e8b3c39bae" => :high_sierra
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
