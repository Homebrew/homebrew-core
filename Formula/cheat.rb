class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.1.0.tar.gz"
  sha256 "b392c3a77eda61f4b1f0991cb30c6202f74472713293e73f645fb697665ca72c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "78ed17a3a87db6a169c5c984ccb7d4083641679f871e208879b45962511a0a5b" => :catalina
    sha256 "22a32893fb8c620146fb784454c0337116b174d62d085b7e3050a5bc5981ef5a" => :mojave
    sha256 "d60d58f26760c6d9c125c02a8d8238cc159e040f3bf07d2b016f6b4dbfc5ba9d" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
