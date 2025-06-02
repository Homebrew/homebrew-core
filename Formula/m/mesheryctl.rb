class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.92",
      revision: "9ede6e90351cbc46d1bf4736f0985fc0de5d28c8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bd5a8c2b289b835856b1fd6fcd21531ae4bb64179228045dd7839afd885aa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd5a8c2b289b835856b1fd6fcd21531ae4bb64179228045dd7839afd885aa55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bd5a8c2b289b835856b1fd6fcd21531ae4bb64179228045dd7839afd885aa55"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe06973ddcd82b654ee6989f98f2dcf36a20b3b8215056e67b67854ce79f9dc3"
    sha256 cellar: :any_skip_relocation, ventura:       "fe06973ddcd82b654ee6989f98f2dcf36a20b3b8215056e67b67854ce79f9dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e833a6532d020931d289523c9bf15caaf06f7ae1bce03b694681f1a360ff33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e169c622d4e12cf07556d682a12069011f6f8b87727575b1a14451ea831bcbb"
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
