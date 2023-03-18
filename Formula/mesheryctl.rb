class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.65",
      revision: "68fd063d7e9f12cc4a13ed4f0a2426f7af49bf4a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b38a6daa121c8652020ade02e27bfd0f1fb2dd583b844bd0e9731cb7634affe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab20f8115ccd48b793b8b9a08742ad709edd089c095216ae16a4fd2ee1f9d077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b38a6daa121c8652020ade02e27bfd0f1fb2dd583b844bd0e9731cb7634affe1"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c410bc0e405e9aab6e5638957b66d8374ee578fcd08baeabbd240929b7e389"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c410bc0e405e9aab6e5638957b66d8374ee578fcd08baeabbd240929b7e389"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4c410bc0e405e9aab6e5638957b66d8374ee578fcd08baeabbd240929b7e389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4878972cbb00c07133230b0981a811882e9dd1727fd6d9d9a58bfc4847380c"
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
