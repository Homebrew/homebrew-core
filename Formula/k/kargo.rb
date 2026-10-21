class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "81cca68a0fa3943bef713ef630666a9e1d8f73b39311d0152bde7221efc92075"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9ae10e2955f72ff4b7403dffb3f743b3a04abf0bb4c6ca1bba66eb40822fc9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "251bb150b86a757d161a726c37fed70840ee2e13b2ef34b0703b62eb77ab00df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01f23b58dcbc75f69b3c7715ffc1de0a6f46ce1f27884d41f9f755e5ffb1bbd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87c65e0885de42b288b64eaef745b5c128fada716e9f45bd4bda2a469e8606ff"
    sha256 cellar: :any,                 x86_64_linux:      "7ede435a91b023e1a9e13ac87c0688f554bc6f9ceebc938ba54603253c84207b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
