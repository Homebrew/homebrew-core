class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.43",
      revision: "dbf912ba7e5e56951def0fbdff7b9a9163b24ee2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b73a0c3c2ac1d55ec6189a692a109aeb3456e1286e4e99fd4f192e593434e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b73a0c3c2ac1d55ec6189a692a109aeb3456e1286e4e99fd4f192e593434e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b73a0c3c2ac1d55ec6189a692a109aeb3456e1286e4e99fd4f192e593434e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "580bd95e97648a68052aad18331ab45eeb8117340159600a7bcd6f5b65fe26be"
    sha256 cellar: :any_skip_relocation, ventura:       "580bd95e97648a68052aad18331ab45eeb8117340159600a7bcd6f5b65fe26be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e29c6fc88e818ff4dd3571d8e5c14b90ac89c8893096e20b713b6d362b91462"
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
