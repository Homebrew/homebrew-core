class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.34",
      revision: "3e4de1e226bf4cd1f36c72b77e7f46f9caaaaac2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2243939d9db893a4c5d1303a3963e8b61773f8ca1c5a8f8e24314630c75f4776"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2243939d9db893a4c5d1303a3963e8b61773f8ca1c5a8f8e24314630c75f4776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2243939d9db893a4c5d1303a3963e8b61773f8ca1c5a8f8e24314630c75f4776"
    sha256 cellar: :any_skip_relocation, sonoma:         "64c629b4977615ee68baadfe05fadfd7dba6fd98e173199aa65d1a31f7294042"
    sha256 cellar: :any_skip_relocation, ventura:        "64c629b4977615ee68baadfe05fadfd7dba6fd98e173199aa65d1a31f7294042"
    sha256 cellar: :any_skip_relocation, monterey:       "64c629b4977615ee68baadfe05fadfd7dba6fd98e173199aa65d1a31f7294042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e1ff94a5f0cc04276a627b9e6054198301e624846905d33660e82d28d22481"
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
