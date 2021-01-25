class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.24.2.tar.gz"
  sha256 "95f629d57b459a3414af0582c20835edc970ec83a2c791cff97e5b8aac3b7025"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3b26ef0593a1255e23213d53a3eb04686e9b788b2984076bc87ba91fa89d0542" => :big_sur
    sha256 "d986e49449817c6820eefc699ae063a53e12afa8fce9c6898533669bbd2bd843" => :arm64_big_sur
    sha256 "fd59e8da5b076eafab4d02059e9d62685f47c8ffd2b041b88b215bc1813fd50e" => :catalina
    sha256 "95987d404639543c6174033c8f76a0d43549ffddbddba46759816d5c668d638c" => :mojave
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
