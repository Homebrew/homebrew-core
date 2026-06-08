class Mcptools < Formula
  desc "CLI for interacting with MCP servers using both stdio and HTTP transport"
  homepage "https://github.com/f/mcptools"
  url "https://github.com/f/mcptools/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "048250696cd5456f9617a70d92586690973434f0ad6c9aa4481ef914fb0ef8af"
  license "MIT"
  head "https://github.com/f/mcptools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41935d9845af05cbe0d5845d48d39ba22cd2acaa506a7ef3b8d0236bd6a506c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41935d9845af05cbe0d5845d48d39ba22cd2acaa506a7ef3b8d0236bd6a506c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41935d9845af05cbe0d5845d48d39ba22cd2acaa506a7ef3b8d0236bd6a506c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "61800bc1654c7d0bd81dcd620ab5807135d2f67644e5adf5b2e12c6441c166d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fe149647de823687588e4048620c3b8e1db66f3338df6f08fc837cca575a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ffab019c9f9ada55db8b089ed043c3356f93544dc5a5d58667f22d22f9724a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/mcptools"

    generate_completions_from_executable(bin/"mcptools", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcptools version")

    output = shell_output("#{bin}/mcptools configs ls")
    assert_match "No MCP servers found", output
  end
end
