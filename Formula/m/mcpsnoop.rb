class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8f30e4bee02d7656d423d86da272af7907185729ce070de3ad40bcbd006229d7"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abdca28be4831f5fa602efcb1797992aa0676e697750386ae1d6d6d877a29ef5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abdca28be4831f5fa602efcb1797992aa0676e697750386ae1d6d6d877a29ef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abdca28be4831f5fa602efcb1797992aa0676e697750386ae1d6d6d877a29ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d13540a5d74d7a67cc56c4187faa14a8db29ea92bb388c6a897cf6f1c72b4b4"
    sha256 cellar: :any,                 x86_64_linux:      "a297d5eab9cc99ffbcf0758fb97ff4a867e8cce586e86bd7f3fdb3a6c761d2db"
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
