class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.68",
      revision: "60428ddd952fb2506e8fca8e1db14b704c374d4c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed80b80b6831be13a5863939825f8c61141216e72a5f3e67e9106b5f419f8c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed80b80b6831be13a5863939825f8c61141216e72a5f3e67e9106b5f419f8c61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed80b80b6831be13a5863939825f8c61141216e72a5f3e67e9106b5f419f8c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "467c56c90782c0a1cb84f58e4b2a10e43a4509a071092dbe28943e8feb73a2a8"
    sha256 cellar: :any_skip_relocation, ventura:       "467c56c90782c0a1cb84f58e4b2a10e43a4509a071092dbe28943e8feb73a2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b24ff8da67b29d177e00784525f800b4cdad587c5a5cde60d9bf67678c0efc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3a90f0faad62d9ead4d5d26c8106aa2364d43d3a249aa69eef82ce1585f286"
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
