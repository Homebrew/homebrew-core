class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.7",
      revision: "ff356fb5e7265c453f76bcc9b96f4c77201c6535"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42a2f00ea47a0ecc404953fc7b525570fcd1e4b492bf45337692c6f480164a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002c2ea4ada6289f030ffd433a915465df95b6d4110d62c729391c643ffab22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f678c2cc15e11c7eeebe0c8436d6031b948a72f2f93f58007ebe8a62ddedcf39"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd35467a4db67720681b2d50c6dc7854b184ed64e3b93084f70efe107f5d60fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c0c5b39e0101bb4281c310710204d20bf9401580abd2e89d59fb5f2e87aecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53821c44eef9358e2cb70978aeba3cdf0f79b489ca016bec9928a39d7f34831e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
