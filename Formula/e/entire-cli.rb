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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8dac3ec39631b9469d3d6d7457a6afc1f523d367f269b127ed9ba3d38d74d47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8dac3ec39631b9469d3d6d7457a6afc1f523d367f269b127ed9ba3d38d74d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8dac3ec39631b9469d3d6d7457a6afc1f523d367f269b127ed9ba3d38d74d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd2f46df980d760a39b7c390288b6b19671aa68bbb790c48a4473bac925a4e7e"
    sha256 cellar: :any,                 x86_64_linux:      "630d13d4423036dee5bbaad40afe3f1c347858b8d02d2ed2d82fcdcfd4077c12"
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
