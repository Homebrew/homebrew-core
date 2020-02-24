class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.14.4.tar.gz"
  sha256 "43008dd4ef764ed1f6a5c62a03a541fdf257338a8f4df13cb8dc51ea8e31ca3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "80996b574bcc420b11b5e4936bca5d7b2c702be97ea95b172fb26c9c4663d5b4" => :catalina
    sha256 "f60000ff4ace59dd2b6f067d220158a509984cf6778cd78035186c9c3d21ed0b" => :mojave
    sha256 "bc47e6a12f56578f06fef7de37cac44c333ba6d687aa1559aceed2f33034dc38" => :high_sierra
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
