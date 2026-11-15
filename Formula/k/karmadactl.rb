class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "262c26a7b6c41986b0875c501aa5a3775cfc6c4bc8bfdda3fd0c2ba48c29851f"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "417393a1e6c17eb767c8b5a5536a08d5fb0f0c5ee4afd5d4aef8e3a031203e2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3494722aaf61d517e8c948b0e6dcddd6f3c88fbfe213c9a9fcf39d0591a1a761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbe7e599756cce5402dbecba247ed33dcdd70b58047eb41464a5ae9e8b4489c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b848ae8eb8df020459748b04f3ae902859235eb9565a8341bcb6196215b25d8d"
    sha256 cellar: :any,                 x86_64_linux:      "dff9b8915761bed0aa99ec316ba1aaae1c7e7e4bc775c095fb3af5739c461426"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = %W[
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
