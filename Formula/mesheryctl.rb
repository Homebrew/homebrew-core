class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.49",
      revision: "460e9bd434f26311141090658002a1921ed3a3ba"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17182aa2a031a147e6a681f13535aff4628436eb57406a11a65edc04a66cd5c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17182aa2a031a147e6a681f13535aff4628436eb57406a11a65edc04a66cd5c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17182aa2a031a147e6a681f13535aff4628436eb57406a11a65edc04a66cd5c4"
    sha256 cellar: :any_skip_relocation, ventura:        "22a9108d81273b5444bda36063f3caba586742a77f667f09848084ab3833d855"
    sha256 cellar: :any_skip_relocation, monterey:       "22a9108d81273b5444bda36063f3caba586742a77f667f09848084ab3833d855"
    sha256 cellar: :any_skip_relocation, big_sur:        "22a9108d81273b5444bda36063f3caba586742a77f667f09848084ab3833d855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fec001c317f90c3e70a7eb6acf059f9ac0bb3ad66531a9cd2bee16a5bfbf47"
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
