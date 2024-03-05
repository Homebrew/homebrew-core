class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.28",
      revision: "baf4a65b9fbd6d98ae98e8170e4234b6da969c88"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b3aab7d774c8e8135ad51a2bc97bc65fe0a2d0d91a638ea3e4d82742e8ff00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b3aab7d774c8e8135ad51a2bc97bc65fe0a2d0d91a638ea3e4d82742e8ff00a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3aab7d774c8e8135ad51a2bc97bc65fe0a2d0d91a638ea3e4d82742e8ff00a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c507cef6b888f83dd11fc060f4c4a415cc05fff2096403d35cf6219161856ae"
    sha256 cellar: :any_skip_relocation, ventura:        "3c507cef6b888f83dd11fc060f4c4a415cc05fff2096403d35cf6219161856ae"
    sha256 cellar: :any_skip_relocation, monterey:       "3c507cef6b888f83dd11fc060f4c4a415cc05fff2096403d35cf6219161856ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71cf6d4e4e0db086e078aab295a8bcda865b5fd3c3ae14990564711a25161063"
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
