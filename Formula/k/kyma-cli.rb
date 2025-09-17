class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.1.1.tar.gz"
  sha256 "bb071d32be5722adb9b6808b578a370deb0ec07429115c68cc11f329f79c4625"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2de0805a0cec068de56bf19469c6b21f86dbe5ab7a6663476c9a8e4b1bbf672f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b365290a10b1f3d4fe5493cf6e68b614ddb602c3f15db68fc4f3aee1ea58c066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288b295c4120100fd5ac9b05b777c99d3d79302f91dd40f9c08e4c6e966f8862"
    sha256 cellar: :any_skip_relocation, sonoma:        "998d817311dab475e1d951f23424b1e755495d6043ba536c9e702057bbf34889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6d36a1c82438ba3d009a66b3ef87a92d1454da2d112979107fa63b6e8d1cf0"
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
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
