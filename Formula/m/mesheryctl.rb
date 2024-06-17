class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.74",
      revision: "ff94671da80712b413630d7c5731923f0ba51e2b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1818e1c51ca7f4c8240522c65b1c53af44a32f6e9cef4189a4d4d0c5d56e3c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1818e1c51ca7f4c8240522c65b1c53af44a32f6e9cef4189a4d4d0c5d56e3c26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1818e1c51ca7f4c8240522c65b1c53af44a32f6e9cef4189a4d4d0c5d56e3c26"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dc278cd1dc6f2a76f9a17788ee4c923f2f7b500ea047ba7e5e16a9c34b128d4"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc278cd1dc6f2a76f9a17788ee4c923f2f7b500ea047ba7e5e16a9c34b128d4"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc278cd1dc6f2a76f9a17788ee4c923f2f7b500ea047ba7e5e16a9c34b128d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49fcfe48fa4a842fde3ceb7d7d7228f024ce5c42b957f559443e55340655d1ef"
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
