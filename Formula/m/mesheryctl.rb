class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.27",
      revision: "74d74bf119cffd7132c60d36b6cf7df6cbdf2df9"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8032c72da98c89136043a44df7dd269ba02b266592a594a54ca5f97b7e124921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "511fbf30bfb031943c333476bdbc09dcd6d59088823b1cf55ea4c406a65ff198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4782d47e94946aebc46ac986b3890ea0ec3f111ce5a49b437fb8144e8e5a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a21860f28c44bb2d240ed9bb98bdeaed22d8ffc6e620558198734844e0aa7f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb69c718700b3a88842b73da7866da15e05e079db87d63d799077ac5a73ebef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4afc979601de8ab450fda03649cb35530ace54e107169957c829efb1964817e5"
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
