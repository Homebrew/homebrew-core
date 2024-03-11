class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.31",
      revision: "e5d5257ded21bfe07b2ee3f886ee4476651df6e2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5911e2e945d601184de88a5158a8fbe698417b0ab258afb311adf4422831b7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5911e2e945d601184de88a5158a8fbe698417b0ab258afb311adf4422831b7db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5911e2e945d601184de88a5158a8fbe698417b0ab258afb311adf4422831b7db"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6e8a88ce5547a42e604be5fdb7b49676811f702b8c9ab804a1f50197e47cfe9"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e8a88ce5547a42e604be5fdb7b49676811f702b8c9ab804a1f50197e47cfe9"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e8a88ce5547a42e604be5fdb7b49676811f702b8c9ab804a1f50197e47cfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5012ba15cdc5ed04330fa9e373bb8b80e3c14a1444c9cf255cbad8148d266dde"
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
