class Mcptools < Formula
  desc "CLI for interacting with MCP servers using both stdio and HTTP transport"
  homepage "https://github.com/f/mcptools"
  url "https://github.com/f/mcptools/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "048250696cd5456f9617a70d92586690973434f0ad6c9aa4481ef914fb0ef8af"
  license "MIT"
  head "https://github.com/f/mcptools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9ed8a807126e862356c88f8d07ae06e2b363b7d2dde046c3a956e96844bdf62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd293a1418a1f5bed9049cbe3a7adfcf0da1b90fa3ec205b1535ded3d134e9d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd293a1418a1f5bed9049cbe3a7adfcf0da1b90fa3ec205b1535ded3d134e9d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd293a1418a1f5bed9049cbe3a7adfcf0da1b90fa3ec205b1535ded3d134e9d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab73dfea053a7272cd6afabc3d36da454d85fd304c7fc340e143863b912d88e"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab73dfea053a7272cd6afabc3d36da454d85fd304c7fc340e143863b912d88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634ea303a4300ab4a6eb836c866d646954d380e9238d18a484b63ad0719c3d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc017eb921064bcb0820f8f141510aded2edc131bac3e2901c36ea0a6b2b773f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/mcptools"

    generate_completions_from_executable(bin/"mcptools", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcptools version")

    output = shell_output("#{bin}/mcptools configs ls")
    assert_match "No MCP servers found", output
  end
end
