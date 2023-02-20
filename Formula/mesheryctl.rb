class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.52",
      revision: "d69f9509b3d38656cb0e93142a824710f0baeccd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3dcdf2a79e1fd601a7cb71438ed3a6bd9ba2cd7a7f1cf57fcfbf6fc38b65add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3dcdf2a79e1fd601a7cb71438ed3a6bd9ba2cd7a7f1cf57fcfbf6fc38b65add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3dcdf2a79e1fd601a7cb71438ed3a6bd9ba2cd7a7f1cf57fcfbf6fc38b65add"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e926dafde4e81213a101f65a49ef9f6f4e3f86cb0f277ed925361490db12ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e926dafde4e81213a101f65a49ef9f6f4e3f86cb0f277ed925361490db12ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6e926dafde4e81213a101f65a49ef9f6f4e3f86cb0f277ed925361490db12ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd9c81ee77af77c24e27fb9ec0d289aa8456ef32db8086cb6fd52df23b13f64"
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
