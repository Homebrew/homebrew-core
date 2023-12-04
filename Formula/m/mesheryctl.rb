class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.0-beta-1",
      revision: "d0fe6ae0782cbd769a5ddd016499df45f73aa150"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df1634f562f58df10fc0e92b8f1764b049d6494f3600303a10ab2a919642510e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df1634f562f58df10fc0e92b8f1764b049d6494f3600303a10ab2a919642510e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df1634f562f58df10fc0e92b8f1764b049d6494f3600303a10ab2a919642510e"
    sha256 cellar: :any_skip_relocation, sonoma:         "55086ed5bf45577d4b2f40ca1734f1a96e7ac3ba9aad477dfa4d298bf322605c"
    sha256 cellar: :any_skip_relocation, ventura:        "55086ed5bf45577d4b2f40ca1734f1a96e7ac3ba9aad477dfa4d298bf322605c"
    sha256 cellar: :any_skip_relocation, monterey:       "55086ed5bf45577d4b2f40ca1734f1a96e7ac3ba9aad477dfa4d298bf322605c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7280942951fbae53aa6317514c0b18e73f7251c3cc0c75419b201f4c835f1248"
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
