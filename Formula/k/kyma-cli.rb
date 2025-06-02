class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.0.0.tar.gz"
  sha256 "b92eb18d96d4a47e581dde9fca3fc084c5d52af342a8dc6eb682a09b3e5b12ef"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4014dd109281c286199191b2b2fc55413c4693db0580a192c02cfc4a94b96594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4014dd109281c286199191b2b2fc55413c4693db0580a192c02cfc4a94b96594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4014dd109281c286199191b2b2fc55413c4693db0580a192c02cfc4a94b96594"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ffb6fe90d8c3bc33e677490a6296f83aae63ac35a6656d5f2bd94ebb279a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "06ffb6fe90d8c3bc33e677490a6296f83aae63ac35a6656d5f2bd94ebb279a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45737ddf5c24904e45ed8059c0fd608b43e8b58669c3a755053a2f4195c7f150"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", "completion")
  end

  test do
    assert_match "failed to create cluster connection",
      shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)

    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")
  end
end
