class EntireCli < Formula
  desc "Capture AI agent sessions in your Git workflow"
  homepage "https://entire.com"
  url "https://github.com/entireio/cli/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "8a502337be115b042e0b873006f0280243a29e1bec650bcfe21e8e890dc814cd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9da4d1f8c7b15b29fea35147421089fbe2b951d7f8c349bfccd1bb496bcfed01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9da4d1f8c7b15b29fea35147421089fbe2b951d7f8c349bfccd1bb496bcfed01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9da4d1f8c7b15b29fea35147421089fbe2b951d7f8c349bfccd1bb496bcfed01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9dc405a492135b064058286ee8425673209c3cbb2bc3ae9a21278909c24dcc2f"
    sha256 cellar: :any,                 x86_64_linux:      "6748e31e1ebca70a0b32fc5ca46601b82d394cb5e3e08971909a41b4d7d0949e"
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
