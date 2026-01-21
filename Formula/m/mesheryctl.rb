class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.200",
      revision: "e541c782458b887e99f99d8fa0bb182b916a1440"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45f431e6386d309d3f1903c0c4713f32be4ba3d89155de9693d239307d1ec79c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e901a9bffb0451683f1b6114a5c8709624c3f4d73f51f2ae061afed6635c7854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ac8213030f60037105831fdd5939ddd7534c7ffa3fe11aa6c39a294d1fd345"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3212e0a3a751d66b8aa2e64803221d0b43f00055d731d5b16146816b324904b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d3468332169fdafd2a5f5db1730455d7efe8d771b200c4576ae1c15bcc12f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac3e969a8d6747cb3508644a5e42570f31bbc92cd44c8abfbcc7676612f39760"
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
