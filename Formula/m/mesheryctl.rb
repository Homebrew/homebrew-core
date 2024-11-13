class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.147",
      revision: "7de18c96e2819f132f6c7d61caed19fbdc582d54"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5bb98d13c49ce0ac1902d952a8275c61c414e100035d66ad0b4ddbb366a14d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5bb98d13c49ce0ac1902d952a8275c61c414e100035d66ad0b4ddbb366a14d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5bb98d13c49ce0ac1902d952a8275c61c414e100035d66ad0b4ddbb366a14d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd7a173e096d539eed090a42e1d6fc85ef102a7eb71b90a23bfbc78e60726778"
    sha256 cellar: :any_skip_relocation, ventura:       "fd7a173e096d539eed090a42e1d6fc85ef102a7eb71b90a23bfbc78e60726778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dad681349d26a3de3209cd075f0ef516a453bb8fd224b3814a250049290cc33"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
