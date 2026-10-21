class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.337.tar.gz"
  sha256 "46013407e0592184eeb848890e8f42f2dd74b851c5fed03e602c40d722a740ef"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1f101056926f7e4533ef978605b9d9a169ef1e2367263d90123fb6a5ddc124f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1f101056926f7e4533ef978605b9d9a169ef1e2367263d90123fb6a5ddc124f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1f101056926f7e4533ef978605b9d9a169ef1e2367263d90123fb6a5ddc124f"
    sha256 cellar: :any,                 arm64_linux:       "622c9aa3998110647a1f00b12ecf301cf44259d5a5944344badb058014b6d4e4"
    sha256 cellar: :any,                 x86_64_linux:      "e5246c1f2419da32bcff591e52ca52615d0fefd519bf58525ad8279a728a6f67"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
