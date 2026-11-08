class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://github.com/git-pkgs/forge/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "eb3b7ba99ed4e459aa10df347bb95f782106062816833a157a3c2f62a96a4d20"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2f6f4b9d5cd4247528891bbcfd364f71fb6bcaa394ffe0a27d7c9cd52fd2837"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2f6f4b9d5cd4247528891bbcfd364f71fb6bcaa394ffe0a27d7c9cd52fd2837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2f6f4b9d5cd4247528891bbcfd364f71fb6bcaa394ffe0a27d7c9cd52fd2837"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40e2204a1d88fc22c8d372453ed0e40ee16e5ae16c04df6d7784dda10c1708c6"
    sha256 cellar: :any,                 x86_64_linux:      "070d21565e565efa0451dc09952577d31b2c56196be8f1a070f6f65e3dc8f405"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/git-pkgs/forge/internal/cli.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"forge"), "./cmd/forge"
    generate_completions_from_executable(bin/"forge", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")

    output = shell_output("#{bin}/forge repo view 2>&1", 128)
    assert_match "Error: reading remote \"origin\"", output
  end
end
