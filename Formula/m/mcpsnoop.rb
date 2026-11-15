class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "192e643eb897aef5f3025f00b0ba5b09d2eee2fb2a79b4c00de1e4e602573a88"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c15a8afb0e1a9b1d896fb35ceea1720e118540e055f95e4ffb2af642bd76beec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c15a8afb0e1a9b1d896fb35ceea1720e118540e055f95e4ffb2af642bd76beec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c15a8afb0e1a9b1d896fb35ceea1720e118540e055f95e4ffb2af642bd76beec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b887fca1c93c386f5c640170aaf514fc168954d60b24b7d2225ba09001a547ca"
    sha256 cellar: :any,                 x86_64_linux:      "d4056da730569c7478d51ed63336967869f8b398feec3deaa047788e0b09637f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
