class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://github.com/git-pkgs/forge/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bd5515d68261101733595e2410124fbc4118763a42ff56464820d078f0ee1ba3"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82e6979f49f925e93c873576f97ee8482268a9054750ea7ce0e50e6107b080a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82e6979f49f925e93c873576f97ee8482268a9054750ea7ce0e50e6107b080a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82e6979f49f925e93c873576f97ee8482268a9054750ea7ce0e50e6107b080a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7446015d0953f26fa1ddbcc6658e1a78ab65830df5499b5c4ca57392fcdf0160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a876bd457d435a399c3a5f7418a717e53f53d14e50ed4c1c297038a38a892b"
    sha256 cellar: :any,                 x86_64_linux:  "a9dbf0825827df1248e62e62b122fcdf873ed83c1dd95c2a8358edb091434aaf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/forge/internal/cli.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"forge"), "./cmd/forge"
    generate_completions_from_executable(bin/"forge", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")

    output = shell_output("#{bin}/forge repo view 2>&1", 1)
    assert_match "Error: reading remote \"origin\"", output
  end
end
