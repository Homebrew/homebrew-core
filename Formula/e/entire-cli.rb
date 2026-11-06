class EntireCli < Formula
  desc "Capture AI agent sessions in your Git workflow"
  homepage "https://entire.com"
  url "https://github.com/entireio/cli/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "cc689387a5552621178e4a69317bc86096502b05694047deecc0b085ad5e079c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1203d43fafe4cb7d64d8b94b127b7f5009bd7835cc5a6fd51cf16e1b655ad964"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1203d43fafe4cb7d64d8b94b127b7f5009bd7835cc5a6fd51cf16e1b655ad964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1203d43fafe4cb7d64d8b94b127b7f5009bd7835cc5a6fd51cf16e1b655ad964"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5288a14abbd72ddce9c5495e9ad6bec1705041ee5f56caea75ae58875b21a48d"
    sha256 cellar: :any,                 x86_64_linux:      "4d0626b8b5bc6f371ea02406d4ccdfa3629a19ef51911ade04639e019552e4dd"
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
