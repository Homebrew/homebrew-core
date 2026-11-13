class EntireCli < Formula
  desc "Capture AI agent sessions in your Git workflow"
  homepage "https://entire.com"
  url "https://github.com/entireio/cli/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "3897cb720b07b9ba3e57415d603e7a54de88efcb6998f5ba4bb59b583549fd88"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a623d387c61a9b2e88bd547e38ab64382c40e6bc9465c51db7bf2ba255656b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a623d387c61a9b2e88bd547e38ab64382c40e6bc9465c51db7bf2ba255656b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a623d387c61a9b2e88bd547e38ab64382c40e6bc9465c51db7bf2ba255656b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fd21af1eb5fc82456188c882899d3d530e64074d59536eacc3db56277f0f844"
    sha256 cellar: :any,                 x86_64_linux:      "e089a02717beff3d36c7619026f1893a96eb7488c3d93e4f6010c7c3edc4e2cf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/entireio/cli/cmd/entire/cli/versioninfo.Version=#{version}
      -X github.com/entireio/cli/cmd/entire/cli/versioninfo.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"entire"), "./cmd/entire"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-remote-entire"), "./cmd/git-remote-entire"

    generate_completions_from_executable(bin/"entire", "completion")
  end

  test do
    ENV["ENTIRE_TELEMETRY_OPTOUT"] = "1"

    assert_match version.to_s, shell_output("#{bin}/entire version")

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system bin/"entire", "enable", "--agent", "claude-code", "--telemetry=false"

    assert_match "Entire CLI hooks", (testpath/".git/hooks/post-commit").read
    assert_path_exists testpath/".claude/settings.json"
    assert JSON.parse(shell_output("#{bin}/entire status --json"))["enabled"]

    assert_match "usage:", shell_output("#{bin}/git-remote-entire 2>&1", 128)
  end
end
