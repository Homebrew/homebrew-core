class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.57",
      revision: "6f21de6b8ae941ff38d3eea7758264364d96f117"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edacce91ed24f8ff1b441e46988a11d7c49b9ecc6cd581f7d8990e23559e845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edacce91ed24f8ff1b441e46988a11d7c49b9ecc6cd581f7d8990e23559e845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5edacce91ed24f8ff1b441e46988a11d7c49b9ecc6cd581f7d8990e23559e845"
    sha256 cellar: :any_skip_relocation, ventura:        "c435a273f471234de82311031a22e10de7ac3b674dd2bfb1b887c4acffe2f5e8"
    sha256 cellar: :any_skip_relocation, monterey:       "77e2ac553e6630eccc7fc80a3343c2e6d2bed707dc1791de67382673b2f83023"
    sha256 cellar: :any_skip_relocation, big_sur:        "c435a273f471234de82311031a22e10de7ac3b674dd2bfb1b887c4acffe2f5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c44f9a0d467405452931d5c4db2748aad442b3ac197045ad79fd16a5150d05"
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
