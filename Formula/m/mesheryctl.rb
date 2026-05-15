class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.20",
      revision: "9c6a1e085d7a8a3c892fb098d4f7e7dc372ba538"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae622be1e7fcc33aa2d09dadf181ab92e2e54456acf34d7fa6a57ce929a9f154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ff8500b626933cb523567425fe2bfbed69fa558cafeba3d15b92e5fc7d861e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857dda70c0805c94a5f59497b774181eca3480aeff96926c7342c456e6f1e998"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7d49d67305d40dccc3a5bedb37064e67ab4ce376d36a2f22db5edf08316c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c75d630917a389639ce89da9770c61172d8096699231e3f177302436ea92d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c4c5f1d9447e71fa804323e4ab02b5eec40ba12b3e7c5f900ee17d4187b4bd"
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
