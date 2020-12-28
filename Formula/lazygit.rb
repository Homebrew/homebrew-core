class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.24.2.tar.gz"
  sha256 "95f629d57b459a3414af0582c20835edc970ec83a2c791cff97e5b8aac3b7025"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6c4483f91e0d0f094caa275376592001baac281620eaf849fa1b877915fe76b3" => :big_sur
    sha256 "cbc70da374c540a7414c913aa512280931a010eddb57c52af92e6e03d0ef3e4a" => :arm64_big_sur
    sha256 "07e95b342ceab314744d3833eefb4e749315910fdbefecf024529bdb7a3f6561" => :catalina
    sha256 "c0f9bba3a0975ee7ee00ed15e1b7b302d83d3188f8ef88fd03d205cde33d1339" => :mojave
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
