class CliAgentLint < Formula
  desc "Audit CLI tools for AI agent-readiness"
  homepage "https://github.com/Camil-H/cli-agent-lint"
  url "https://github.com/Camil-H/cli-agent-lint/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "bbd84b5536afb99b4668a288747ee1b8083517e4f71e9700639c3a1376cb41ba"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Camil-H/cli-agent-lint/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"cli-agent-lint", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cli-agent-lint --version")
  end
end
