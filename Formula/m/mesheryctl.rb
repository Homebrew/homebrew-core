class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.128",
      revision: "0700d8d68ce069b90a07481400501f2cf5259bcd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bedd4f9f3b9effb7d3a79522e6d09534b668566152a846b614600150d71e6fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bedd4f9f3b9effb7d3a79522e6d09534b668566152a846b614600150d71e6fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bedd4f9f3b9effb7d3a79522e6d09534b668566152a846b614600150d71e6fe"
    sha256 cellar: :any_skip_relocation, ventura:        "9616c613bbc98aef444d1c59f5e42770ccd77884f05330d77314d8803e935a31"
    sha256 cellar: :any_skip_relocation, monterey:       "9616c613bbc98aef444d1c59f5e42770ccd77884f05330d77314d8803e935a31"
    sha256 cellar: :any_skip_relocation, big_sur:        "9616c613bbc98aef444d1c59f5e42770ccd77884f05330d77314d8803e935a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fccbd77288aea3b1584d476e952d68dc1383beddcb54f80d4476f18e328fb06c"
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
