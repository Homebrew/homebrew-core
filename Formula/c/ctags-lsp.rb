class CtagsLsp < Formula
  desc "LSP implementation using universal-ctags as backend"
  homepage "https://github.com/netmute/ctags-lsp"
  url "https://github.com/netmute/ctags-lsp/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "216499e15257242c11449bdba0ea8b47fbadfc1866357c50cd6424a227d67910"
  license "MIT"

  depends_on "go" => :build
  depends_on "universal-ctags"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctags-lsp --version")
  end
end
