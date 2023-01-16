class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.44",
      revision: "c1f64618297154b946ef5f4e5e9bcdba55554b73"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a929872d0b2648febb978a9c7977bca33efa1176ef51c59c0832d5cf870c5431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a929872d0b2648febb978a9c7977bca33efa1176ef51c59c0832d5cf870c5431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a929872d0b2648febb978a9c7977bca33efa1176ef51c59c0832d5cf870c5431"
    sha256 cellar: :any_skip_relocation, ventura:        "12d05e4b27055ec82e43c8d14a4b8e1c17d158a362cf3d6a1ede79723063cd76"
    sha256 cellar: :any_skip_relocation, monterey:       "12d05e4b27055ec82e43c8d14a4b8e1c17d158a362cf3d6a1ede79723063cd76"
    sha256 cellar: :any_skip_relocation, big_sur:        "12d05e4b27055ec82e43c8d14a4b8e1c17d158a362cf3d6a1ede79723063cd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4060cd0fcdfd33829ab9f523545c573ea871c923f9c06ee81addf48a0db450"
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
