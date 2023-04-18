class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.81",
      revision: "1f587170b8db9429ecc812c1ac783127c2c3e8e5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9562a5073c7cb9de09c609a4752b59aad4d9739fcf2b62af48b781aa23904b4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26f2e4da9bd337bce640ca07e8436a0d153d309f86477cb8dd9314ce6a5489c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26f2e4da9bd337bce640ca07e8436a0d153d309f86477cb8dd9314ce6a5489c9"
    sha256 cellar: :any_skip_relocation, ventura:        "4f982b43947825e1c602c0c62af24ba8fb8b5b25aa963d2f67bc13ce61fbf109"
    sha256 cellar: :any_skip_relocation, monterey:       "d9d1189f7aac3f7037b5076cf04943091d3e2450716fef483e2f72936214a0d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9d1189f7aac3f7037b5076cf04943091d3e2450716fef483e2f72936214a0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ffe78b2c2780b22eb40b07a39ace3619146515a2d2465d17a370075e25567a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
