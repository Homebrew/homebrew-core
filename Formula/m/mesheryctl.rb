class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.29",
      revision: "b70afc6881538c0c54fb668800444859e67b1f7d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f656d7bdff43dab550051a643878a2940a593c043a87fe0518968ac384a27dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f656d7bdff43dab550051a643878a2940a593c043a87fe0518968ac384a27dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f656d7bdff43dab550051a643878a2940a593c043a87fe0518968ac384a27dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8133d9f6ab032d7b2bd71bc59c26d9577dad3e76efb3ffd95f6a9b7ff58f1dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d8133d9f6ab032d7b2bd71bc59c26d9577dad3e76efb3ffd95f6a9b7ff58f1dc"
    sha256 cellar: :any_skip_relocation, monterey:       "d8133d9f6ab032d7b2bd71bc59c26d9577dad3e76efb3ffd95f6a9b7ff58f1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b3dc4782d3b8571b23f25ab7f8b92e454915cee4662f11341c97c819c99433"
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
