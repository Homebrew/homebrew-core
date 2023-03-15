class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.65",
      revision: "68fd063d7e9f12cc4a13ed4f0a2426f7af49bf4a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edbcf711e720222336795369afec94ba104dbe12e1041a918f7d351c34926d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc43171c08cf30365121c3a529f44765cb9c4c9a14ccdfd90cdd28b76e4671d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edbcf711e720222336795369afec94ba104dbe12e1041a918f7d351c34926d3f"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a1a9b7772931d5da84713e20ba4576731c05aa8a1bbe540e6027ed0e5f5dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "a86282682494ea59c436c2954af846ada9428ea1fa7226ba3a48e386b4c9f4f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a86282682494ea59c436c2954af846ada9428ea1fa7226ba3a48e386b4c9f4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa0e93019161425cdca80294a331f00f6829a005ad55c7e14ce8726b6249c45"
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
