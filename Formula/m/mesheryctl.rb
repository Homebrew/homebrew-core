class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.107",
      revision: "81d3a1467a2a2750beeac73ba3d99b4bfb8bdc9a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3442778fa4a928604b203c4e8d884ff636a3d5670aefaba07699d87ff1a5e6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3442778fa4a928604b203c4e8d884ff636a3d5670aefaba07699d87ff1a5e6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3442778fa4a928604b203c4e8d884ff636a3d5670aefaba07699d87ff1a5e6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f098df5c664e3cbb7ba1220f2093e08dda36436550b56945f4787e8093daa56d"
    sha256 cellar: :any_skip_relocation, ventura:       "f098df5c664e3cbb7ba1220f2093e08dda36436550b56945f4787e8093daa56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fd5445e868a9451ce79b041de6f0421a5894e2812f209fd3e995a92658561d"
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
