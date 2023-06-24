class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.98",
      revision: "6998ec45ea22109d8707e78dbd62ebf56dc5f949"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26bdbcd58cb73bc0ff2eb17e06bf4f5d5d7072b68e96ac8d63b214e15bd1509a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26bdbcd58cb73bc0ff2eb17e06bf4f5d5d7072b68e96ac8d63b214e15bd1509a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26bdbcd58cb73bc0ff2eb17e06bf4f5d5d7072b68e96ac8d63b214e15bd1509a"
    sha256 cellar: :any_skip_relocation, ventura:        "c472dc9afc02704715d215c41316fdf6247c30cfd8fd01c0f9715c167f484831"
    sha256 cellar: :any_skip_relocation, monterey:       "c472dc9afc02704715d215c41316fdf6247c30cfd8fd01c0f9715c167f484831"
    sha256 cellar: :any_skip_relocation, big_sur:        "c472dc9afc02704715d215c41316fdf6247c30cfd8fd01c0f9715c167f484831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7aa597b6c54984b2ec4c23f0c151167b2b28eea14474a27dc75dc1f01659fa1"
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
