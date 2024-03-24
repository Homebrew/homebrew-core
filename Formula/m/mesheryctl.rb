class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.37",
      revision: "e55af207f4a34ea1b7cb1c27b4f827cea1d86c04"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a303b5e4cf291c6e2796230acdb899febb35dd8b738716d9e4d8133002df06f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a303b5e4cf291c6e2796230acdb899febb35dd8b738716d9e4d8133002df06f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a303b5e4cf291c6e2796230acdb899febb35dd8b738716d9e4d8133002df06f"
    sha256 cellar: :any_skip_relocation, sonoma:         "16741fa43a6ad1633e2266c19bcad00533ae95d84b834e29a147259c3ee243b8"
    sha256 cellar: :any_skip_relocation, ventura:        "16741fa43a6ad1633e2266c19bcad00533ae95d84b834e29a147259c3ee243b8"
    sha256 cellar: :any_skip_relocation, monterey:       "16741fa43a6ad1633e2266c19bcad00533ae95d84b834e29a147259c3ee243b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c7ace60652770285557a0b2cda07349be3c9712f7e0ba8e8414bc8b5271cb8"
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
