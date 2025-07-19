class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.121",
      revision: "22a5c6ce570e34a71b421b90be1f0cbe34840534"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7cbcca8d50fad43a6637b5e559956ada45e11b88d703911d359ab527d942c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7cbcca8d50fad43a6637b5e559956ada45e11b88d703911d359ab527d942c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7cbcca8d50fad43a6637b5e559956ada45e11b88d703911d359ab527d942c52"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f18e819d29ea3da6c5c84a41e30a357ff51477ccdd2b9cea66d24d55b3a196"
    sha256 cellar: :any_skip_relocation, ventura:       "02f18e819d29ea3da6c5c84a41e30a357ff51477ccdd2b9cea66d24d55b3a196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "888072e674fec90c1050cba0e7644468c77db0ebfe99efab78aa85ba69e61b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08123aa645e77b47cd6839cd92b911295408036111397a69255e35825192047"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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
