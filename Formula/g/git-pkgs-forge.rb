class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://github.com/git-pkgs/forge/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "eb3b7ba99ed4e459aa10df347bb95f782106062816833a157a3c2f62a96a4d20"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d96f910f964e5500a31ea6951ee2891605159dc6c0b434af83c8658f8d34d7cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d96f910f964e5500a31ea6951ee2891605159dc6c0b434af83c8658f8d34d7cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d96f910f964e5500a31ea6951ee2891605159dc6c0b434af83c8658f8d34d7cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5ef82351a06e58f354b14cb62a305735c4617af23a6ac7d0979c61956400d51"
    sha256 cellar: :any,                 x86_64_linux:      "c6e22c760966bd9d694078e46d7990a6161c787f300fff15beb1f125c87aa4e2"
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
