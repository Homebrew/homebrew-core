class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.210",
      revision: "db115bf8b7b9af9e7acc11e41a51c5843c613e82"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e702a7ded0ba6869fd83591eb0d54229974ace019541b2c8d6f34d6f3f60bc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b57d60807cc942a8802aa7e911179f5a6029bc3fa0992219863e245713691682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b581c2a45748b58f32a5dca1c3e87844b821ace1939685a2d157c4600ba55d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8504e887a97925e5b5702cf0a945a987678da74d6c7b3829dccf9ea6a8357cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c3dcc825ef53e72e4c1a6e24953e8b6651c511732212c88b45fc22c2040e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d744228c4df4fb1d1b01ae715be14837a6e505b19964318bce81b531c0fb694"
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
