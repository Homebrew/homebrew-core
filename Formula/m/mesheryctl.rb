class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.124",
      revision: "890b23ad01b64aefa878435dd280fddee2f24418"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c4533f6f98742823339e480d39f28cc29b210a4052431796b16983787b9893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c4533f6f98742823339e480d39f28cc29b210a4052431796b16983787b9893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0c4533f6f98742823339e480d39f28cc29b210a4052431796b16983787b9893"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c8ec9e4e8131bf87429f41966fe7513f1af89a301cc956c3d4695a5fff473c"
    sha256 cellar: :any_skip_relocation, ventura:       "53c8ec9e4e8131bf87429f41966fe7513f1af89a301cc956c3d4695a5fff473c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf9b4c594b7b814aad5d1647e86bcab641aa20419dfb1b672b250c3f7130ace"
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
