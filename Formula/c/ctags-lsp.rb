class CtagsLsp < Formula
  desc "LSP implementation using universal-ctags as backend"
  homepage "https://github.com/netmute/ctags-lsp"
  url "https://github.com/netmute/ctags-lsp/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "86d1090c7281e65aa5f16bb3a06bb57b19b9dbb5f778c108a8f33662236523d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07dec02591ecfd0dfa85f61ae84c1b5a70093b985f5f4660b55fce9e1e1b3d0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07dec02591ecfd0dfa85f61ae84c1b5a70093b985f5f4660b55fce9e1e1b3d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07dec02591ecfd0dfa85f61ae84c1b5a70093b985f5f4660b55fce9e1e1b3d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c1dcb54e6940f7844c2e6399bca9aa2f3463baaa40b30defc759e142e162d67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b861f10435d1970114773831e30d7c4e24aafb1181d018c66bc4e976579b7fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ec0a3be1c4384944d03ded5b109091d28e4ef2e2d8991d2453bc01cea7cc4d"
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
