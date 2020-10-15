class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.23.6.tar.gz"
  sha256 "b2383a70e54a67382b0f052149891d3d0f3e1eba952a0fa5009214c6591dfc6b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c0f8a5b8d3c42ae57082ce605f55134464c4b0de7a0be1c0edf5d8de78241e6" => :catalina
    sha256 "017eb2230fcd14fb654553b67cef18fac3debe50daa540c139d2331f93722ffd" => :mojave
    sha256 "76c6f8e89cd9335386cd5db6f6d13a697f5054a4e13ed4b5cd1a831964cb5db1" => :high_sierra
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
