class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.106",
      revision: "eb9f2435264de223ab261f4e75b90393cb04b2f8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2898b653a377b8528fa533927b7b0ee1eaf04415f33f478eb766156cfa5eaa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2898b653a377b8528fa533927b7b0ee1eaf04415f33f478eb766156cfa5eaa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2898b653a377b8528fa533927b7b0ee1eaf04415f33f478eb766156cfa5eaa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3987183d9e151ce1d28b96230fe071e1e926b370422bdbe5251fa13c8f2b263"
    sha256 cellar: :any_skip_relocation, ventura:       "a3987183d9e151ce1d28b96230fe071e1e926b370422bdbe5251fa13c8f2b263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "747cf4d8c4f11e931919666a889e9c0727a9a57133a74c039d1df76e59c2876f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7db0cb29dbf8bfaf4ee3929e125bade48c985782dbc16697506795979c4e54"
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
