class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.56",
      revision: "bd06fe356a6ce716c32591617b891ea4d065c934"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8abd52abb5d635cfadb2efb35ed1a0c4bc31cd2a8906a7c4e900e38dc42ad8b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8abd52abb5d635cfadb2efb35ed1a0c4bc31cd2a8906a7c4e900e38dc42ad8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feedb1e22f65c34d1218c92dac8632412bc568322f23c229f452ac0acfecc3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "29d70d05d7631e4b7dc60f415abac551369c1bae3180cb0f76604338808a2511"
    sha256 cellar: :any_skip_relocation, monterey:       "82dd2eeeff710db6ba65f76d975a750b11bd05162af62b4d94f00fabc3b16734"
    sha256 cellar: :any_skip_relocation, big_sur:        "82dd2eeeff710db6ba65f76d975a750b11bd05162af62b4d94f00fabc3b16734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e1419c54c1ea9018c6f3bece175594ee8326570b10aa49d7fdf6ab73c683e7"
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
