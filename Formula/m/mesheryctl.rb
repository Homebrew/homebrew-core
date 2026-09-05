class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.69",
      revision: "02aca406b840dd628fd762321865495802b7db28"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6a3171cb2220833b212cf8c89ee6f86fb0a4469ca383a48ea967591126f7b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08bb24cc18e8476d00366e460ebc6f7bfccaea4743be7eac1336ed023b8009cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee1a490001952203b808af5ca935e039d3db6517079d91463366335196c9a09d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9cc5fcd14be6a67d08980d989315b46ec67218199776fa1202ea5570e2d4128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439d6e69541ccee18dc6a7106f35368b980f0bc3e28fd1acf16bab16a8203298"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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
