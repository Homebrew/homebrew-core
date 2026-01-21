class CtagsLsp < Formula
  desc "LSP implementation using universal-ctags as backend"
  homepage "https://github.com/netmute/ctags-lsp"
  url "https://github.com/netmute/ctags-lsp/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "8ec3fdcaca155811ad9b532c6e7b5366d2f0e52d4d673c97652c9f8af8a156b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "babde21b15a5e7a0030c1b66fa745d77200c516d2d76f20a514f82bbb0c86672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babde21b15a5e7a0030c1b66fa745d77200c516d2d76f20a514f82bbb0c86672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "babde21b15a5e7a0030c1b66fa745d77200c516d2d76f20a514f82bbb0c86672"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9fb858ef4ab14a587d7d7927f0f44a69aafc75ee426d106cf0dd63a895e2262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33d6be3e70c549404ecd9a8966cf0295e9d99102c2ab5774f716da1aefe1056f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010b011513cafae9cc758d8f1c8198d5fe6c831f38a4f02f844c3c63a9526b66"
  end

  depends_on "go" => :build
  depends_on "universal-ctags"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/ctags-lsp --benchmark 2>&1")
    assert_match(/^Content-Length:\s*\d+/i, output)
  end
end
