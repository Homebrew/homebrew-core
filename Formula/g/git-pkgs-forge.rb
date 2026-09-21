class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://github.com/git-pkgs/forge/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fb221afbe54cbd8dcfbe5a476df0b6aa93bea83e23455ac8eaca3b7b0eedd33c"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7791a8d3f7a1cf8fa5856972d8382aa0ce2f2d1c82bf06548dff115adedf73e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7791a8d3f7a1cf8fa5856972d8382aa0ce2f2d1c82bf06548dff115adedf73e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7791a8d3f7a1cf8fa5856972d8382aa0ce2f2d1c82bf06548dff115adedf73e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7791a8d3f7a1cf8fa5856972d8382aa0ce2f2d1c82bf06548dff115adedf73e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c8b8fc5132c9740199fb51c5db18f135bd4093c75c278e2a2d85ef318bf74f0"
    sha256 cellar: :any,                 x86_64_linux:      "7f5a232a6eebc2b7faa5a3f7525484446bdbef2da91e84d6bfc5eb49aacc0997"
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

    output = shell_output("#{bin}/forge repo view 2>&1", 1)
    assert_match "Error: reading remote \"origin\"", output
  end
end
