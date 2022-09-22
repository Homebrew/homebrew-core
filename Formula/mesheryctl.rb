class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.9",
      revision: "280d7aa4d0930a378580708a5f5b4656cbebc581"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8203bc7ddce40aafce45753bfce93c463f86a038b41bfdaae1e1413541680212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8203bc7ddce40aafce45753bfce93c463f86a038b41bfdaae1e1413541680212"
    sha256 cellar: :any_skip_relocation, monterey:       "13cbee685a7c16781679ccc25d74a783afd5be1ca89076f454c67fb80da737c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "13cbee685a7c16781679ccc25d74a783afd5be1ca89076f454c67fb80da737c7"
    sha256 cellar: :any_skip_relocation, catalina:       "13cbee685a7c16781679ccc25d74a783afd5be1ca89076f454c67fb80da737c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4834559c8626c35162f640c47b66225a0d00560013a9cd94b5ed037ea178d7"
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
