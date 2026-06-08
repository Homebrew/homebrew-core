class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.5.0.tar.gz"
  sha256 "fc1622315dc59f50bbed79ddce0cfbe8b96a56e9de3a5ab251357a37ed43c665"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a9440995c37bea7af73aaf46ed89947052ad619c15ac6dcd65e97f616390d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53d792f4fd2bb108ca386d41ab2e18f852dd087d56f06a1c2f282d9b69cd62b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b31a23d9a1d0bf4b7450e411588ed91fde783c15a80df6a37eb64524d1e340"
    sha256 cellar: :any_skip_relocation, sonoma:        "82895e01d0dec0fc9311df57b027a8694675ce0636cd1b5b3f102d004817cef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f550aaf588934559ce47270a7884ad668e9f96a536fcd4b3909e2d3606911ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a343698645ca8acfcc3505673eee8d799e0fbfb2e892f67f2de9e03bffbd1c"
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
