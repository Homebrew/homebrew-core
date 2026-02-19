class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.205",
      revision: "f91338c4de7cd85f6d980ad6e61d5bff24240c82"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eee6ce835af43f6ea58c1731ddec6d300dbef1564b4e7617cbfadbe13125ac1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e282c27daec50df28df64e0300c1f24362145917bc7212edbf9e7b794626f6b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0aa365ec60186dddf372a913c99f8f314425d5f68f95e4bfa2bf9e44d7a954f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3c1486054660bed37ca5f585a26f20d4cf92bc83a41f6d3e4dcba109ca0c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ccdd67998b3216447412decafb1223e65d8426c8e31b1aee3819b83af962de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd7c4aad785ed65af3a895488ed1b55ec68e7313cf2238e11e2fbb93c512748"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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
