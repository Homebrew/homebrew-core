class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.29",
      revision: "b70afc6881538c0c54fb668800444859e67b1f7d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c79a2c2e808430367b62eb14c9da377a15bf997c264d445c4c873e9b280b8057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c79a2c2e808430367b62eb14c9da377a15bf997c264d445c4c873e9b280b8057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79a2c2e808430367b62eb14c9da377a15bf997c264d445c4c873e9b280b8057"
    sha256 cellar: :any_skip_relocation, sonoma:         "54210bd1fb5daad852fea1effd9f2703f7f0fd388406bc9ff2bff90af7672ab7"
    sha256 cellar: :any_skip_relocation, ventura:        "54210bd1fb5daad852fea1effd9f2703f7f0fd388406bc9ff2bff90af7672ab7"
    sha256 cellar: :any_skip_relocation, monterey:       "54210bd1fb5daad852fea1effd9f2703f7f0fd388406bc9ff2bff90af7672ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a9787a1342b7d523a964704f46688e67514ffff61b42e279550c9d61f5b12c"
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
