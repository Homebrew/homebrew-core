class Lazymake < Formula
  desc "Modern TUI for Makefiles"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b141ede0499a7ec41c21782d41ebc08a87a95074e9c8c8efc7007d2ebf5e8f9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75d04df33a570496571f15b9ac3394f24760a43e4160f277ac283d24fe849ba7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75d04df33a570496571f15b9ac3394f24760a43e4160f277ac283d24fe849ba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75d04df33a570496571f15b9ac3394f24760a43e4160f277ac283d24fe849ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fab224b41654c30a3286dbbda57b8966e6d1da11f3c1df921c0908317f3e92f3"
    sha256 cellar: :any,                 x86_64_linux:      "ff0a3b5fd6a625e1c9cfe86d4fbd47f6bf2deaea25fe361ec13e4e4c6c3ed479"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/lazymake"
  end

  test do
    # lazymake is a TUI, to verify the command is working we check the help output
    assert_match "Usage:", shell_output("#{bin}/lazymake --help")
  end
end
