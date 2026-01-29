class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.202",
      revision: "29e83e3cc1dc66d4a44fddb999088078bea4dcd5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28996ccce9dc2b7e00351c603fbd816a1d32605335be0586ce844dcfabb36d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56193bc85b67a153d8ce502e70a74aca00cfeb75ccd77b9f642a79ac9e531a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05765a5373933ad85ab6207552f5e7f76267671750d50472dd12a037437f4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b036c0d4306d26cf646c15727c25de685efad98765deb85f6fdf79d5b1090bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea067d37882886e2239cdafa5b652b1aade20a2a9dcf8929126f212b6fdebc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee56a362caaeff26b3f3a2ff52ae9f79e80d166d01ecd4548cfaf48d1e4d11ab"
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
