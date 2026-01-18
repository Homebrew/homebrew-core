class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.3.0.tar.gz"
  sha256 "10ba1e5fe4ad6b9f37ec2b7366f55fa8c7a54718584d9a98ad047926f45f2976"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3738fb8f93f95daaac81de4da069185ed0e575d2c64486573b024e411fd6c076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c95e039f82d5d592b50e3eb6267c5f320e27634aed690cf7cb5cb9becd0e1e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dd4fe2e234281e45679648cbf5037ba93afb84915e47f08d7c57904a7896aa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe2fc388b5474e421876db7fd4a39832d055c23a84cb247c83b0ebc9952e239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5f75763645dfa08fbfadfe35e8b9dcce417a8881108c141585d4b901efafab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9f15e1f70a1777268ee3e2090b0fd905f31557247abbee652ca14fa2b66413"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
