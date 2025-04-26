class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.63",
      revision: "14de39d3d8773810589afefe4b8467a837eb3250"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eab019635e64f62493063d8b71dd70164e9d1fd13fe2a71ca5b62f377cef909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eab019635e64f62493063d8b71dd70164e9d1fd13fe2a71ca5b62f377cef909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eab019635e64f62493063d8b71dd70164e9d1fd13fe2a71ca5b62f377cef909"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e21e9d09f996993ac58f4661a309b8a134b45c11f09eafde5afb34f9b663c0"
    sha256 cellar: :any_skip_relocation, ventura:       "f3e21e9d09f996993ac58f4661a309b8a134b45c11f09eafde5afb34f9b663c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c9765cfee64eec9a44b82ca8c2511b4fcd9f73edb45278ff42777f882ba5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89571f5aa5554e55c614579140ac56e1568e3d676b0c6657e34e3cb8672c6950"
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
