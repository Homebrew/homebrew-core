class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.53",
      revision: "ae960f2642d4ef157815e21273e5a5770bb778ee"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11d870e8523cae9607cb2ba36a3a7401272baacee9499635aa3c3a8fe3fbc4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d870e8523cae9607cb2ba36a3a7401272baacee9499635aa3c3a8fe3fbc4ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11d870e8523cae9607cb2ba36a3a7401272baacee9499635aa3c3a8fe3fbc4ce"
    sha256 cellar: :any_skip_relocation, ventura:        "1a56e863a1b85d1c854ab907b65bb03718a5492fc4731291ebebea71fe3270bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1a56e863a1b85d1c854ab907b65bb03718a5492fc4731291ebebea71fe3270bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a56e863a1b85d1c854ab907b65bb03718a5492fc4731291ebebea71fe3270bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d0acb2e70e7cd17bfa9cc5b2b44a1c5d62953b75ea388cc8048add6f828daa"
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
