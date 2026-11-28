class EntireCli < Formula
  desc "Capture AI agent sessions in your Git workflow"
  homepage "https://entire.com"
  url "https://github.com/entireio/cli/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "8efec2c1d6b37006f96fd2da50e96cf458d8e29dba7e07a58b8eb62f325cd39a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "3c3d30d9a11d06618f3bde4a629d832d3937206065eb0b6e1a24be0d1d9f2af9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72126b0c42a33caaa228718e9804914270a501850b4bb073bb579657a2a1d5fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72126b0c42a33caaa228718e9804914270a501850b4bb073bb579657a2a1d5fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72126b0c42a33caaa228718e9804914270a501850b4bb073bb579657a2a1d5fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af711cb21990e7501ec1b965cf6c4aa1e76c63eb332d8897f89f2642463124f6"
    sha256 cellar: :any,                 x86_64_linux:      "02d89e73cf05f0a0e3d42df76c95d48f9d8e8f418a288e26644b3ded063f633f"
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
