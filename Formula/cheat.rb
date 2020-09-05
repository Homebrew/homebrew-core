class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.1.0.tar.gz"
  sha256 "b392c3a77eda61f4b1f0991cb30c6202f74472713293e73f645fb697665ca72c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "41c06f1b177d35c6f5869bc9b57c330721bdbc991f9ddb3f3496bca7eb091034" => :catalina
    sha256 "80520fe07b136a8afa4202ceb771c4b47fa3afa7e5b622a126a051ba2b72bc88" => :mojave
    sha256 "18a65007d5db1959a80d6a9ff9bbc31ff7c99df1c5af4b3a6420e8afd0d239b5" => :high_sierra
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
