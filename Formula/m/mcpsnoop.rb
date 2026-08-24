class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a0f29d27e44977b4d2ce484bdf5274ee1156beea59f768c85e6c42e54e5e2b38"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0227c3ec8ab4ee40334d63991b37ee311df98b78fe41d7e7ca03c5679c707237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0227c3ec8ab4ee40334d63991b37ee311df98b78fe41d7e7ca03c5679c707237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0227c3ec8ab4ee40334d63991b37ee311df98b78fe41d7e7ca03c5679c707237"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6a6718374121a97666e5a0d90ddb103d5b6ccb76f48c5f26b725b261ffffa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2f0e5b95c1c7fc2422e3b52a8e16959411c11e74cc73d71ea0212a54dae542"
    sha256 cellar: :any,                 x86_64_linux:  "45dfda246d340b8c674cddceab0f5c6c36021604519387b6b8c8c0f1a90f791b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mcpsnoop"
    generate_completions_from_executable(bin/"mcpsnoop", "completion")
  end

  test do
    ENV["MCPSNOOP_HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")

    # Wrap a trivial "server" so the shim writes a real session, then check it.
    system bin/"mcpsnoop", "--label", "brewtest", "--", "true"
    assert_match "brewtest", shell_output("#{bin}/mcpsnoop export -T text")
  end
end
