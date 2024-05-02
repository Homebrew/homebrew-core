class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.52",
      revision: "55c91e75f6a3afa7879ecfcf4fcdd4f4545fb058"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c209c53e81427c07f368493449812e692cd9ca5ab0e5912074205dc6868d1e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c209c53e81427c07f368493449812e692cd9ca5ab0e5912074205dc6868d1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c209c53e81427c07f368493449812e692cd9ca5ab0e5912074205dc6868d1e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff4b2fcadbb4b747456905b2cb22a0937b071b05323e7b9b503877124b3cf0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4b2fcadbb4b747456905b2cb22a0937b071b05323e7b9b503877124b3cf0fb"
    sha256 cellar: :any_skip_relocation, monterey:       "ff4b2fcadbb4b747456905b2cb22a0937b071b05323e7b9b503877124b3cf0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4e3af5c18135b317e39bf0b764225454c86877fbd0b01d430d61b995fcedb6"
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
