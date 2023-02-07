class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.50",
      revision: "8a8eef21cfd7717c879ab2c293fd88e58d402eef"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d46b6a369a647acabc27527d97119d8d4e6c04e1173736e345a1e107679d9ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d46b6a369a647acabc27527d97119d8d4e6c04e1173736e345a1e107679d9ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d46b6a369a647acabc27527d97119d8d4e6c04e1173736e345a1e107679d9ae"
    sha256 cellar: :any_skip_relocation, ventura:        "3f58735dcbd1610590ac9650f9ea6363eca1c47de2e4e9a2e4590e117a55584a"
    sha256 cellar: :any_skip_relocation, monterey:       "3f58735dcbd1610590ac9650f9ea6363eca1c47de2e4e9a2e4590e117a55584a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f58735dcbd1610590ac9650f9ea6363eca1c47de2e4e9a2e4590e117a55584a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d876a21405d14dbcb0ecb3cb7fa7f9c7c7d8680c7971591e32574faba24452"
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
