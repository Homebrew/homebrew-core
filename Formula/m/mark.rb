class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.19.1.tar.gz"
  sha256 "4585c994b484a2c1d734c6258d201234101ddec87857059debe8e46360db2477"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42af843095ecb7f91c83985b69643114e33cf3c8b54bdfd44b07efcecf83d2ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42af843095ecb7f91c83985b69643114e33cf3c8b54bdfd44b07efcecf83d2ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42af843095ecb7f91c83985b69643114e33cf3c8b54bdfd44b07efcecf83d2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89ed2aa27868192567ff9f9a28ccb9db3bd06857a7f2964d3d802f522aa4069e"
    sha256 cellar: :any,                 x86_64_linux:      "3fe52845662479dff54358f98a1079522e90c336eb4be08efbb154c3417a9cb0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
