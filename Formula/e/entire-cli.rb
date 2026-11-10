class EntireCli < Formula
  desc "Capture AI agent sessions in your Git workflow"
  homepage "https://entire.com"
  url "https://github.com/entireio/cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "15ccd6b51fd0e64d1d72bda561b9a0028e496a1a642b1e1585e5b99871a9af9f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3952037f66461e3382f6bc4bcac629201379eb43d5b7603e1a5f625a9c676ccd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3952037f66461e3382f6bc4bcac629201379eb43d5b7603e1a5f625a9c676ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3952037f66461e3382f6bc4bcac629201379eb43d5b7603e1a5f625a9c676ccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31350b22d2373a9ddab95c7cdfa5edc99ab1698231cb88df9dde76c3649acbf0"
    sha256 cellar: :any,                 x86_64_linux:      "fd392e84532cf160467c76df022626c864b154276f9271785b38c065be83ab86"
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
