class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.33",
      revision: "d9a6eb6b738cf1fef374188421c3c4ddf72e5341"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68740533df899d789812f042e0ae4e4678e67af58e755888d8ce8c55b763b25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98cf4c3289a58b75ecd409738c0b9cd1303415319ff0110ea3efd6e13af9fd0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148e7a48881498884177827d31f8f626497286587ce5bcd7a3a3089aca644b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b5d5c3267da3ea6c495554292f1da10dcb47190400d7790da6ed351ba529758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46d51bbb3157e991f85d1eac15aba6792eff4c043d1c85271a061fd8ea2c8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4ffe5d7c95e5f78cd5be0a84e1af42f76329d33e03e87856827241ffe538e3"
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
