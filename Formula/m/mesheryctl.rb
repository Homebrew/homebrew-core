class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.194",
      revision: "99643be8fcf7efb7954d85c7104f5ef0af973660"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ed1d81cd404b6f30b4e23eba4dcac290e59edc1b758fc7f250f33a13336f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ab9f5894812152b4e53ba50d5e14573ee2a7e637491881f12ef8f700725e66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d15c21331578e062500a8d2b931732f2e1da4e62849c05e6ee253f75cfa8fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "27b083d7995f158a351048ec41e06a5e48b34cf04ad5055bb94cd8026e86716e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8acbf27d6ba07a62208ae5b2332546bfa2eaa574a94b11c564ffb4131fce9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00084e2965cf60edad7cfae646a57e790ae249ee93a8a712534fbd003f557c2b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
