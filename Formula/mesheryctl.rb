class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.48",
      revision: "7bd04db4fb2957c51e09bcbc44ef5c827416adb6"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d81ea3417804704ef4983646947fe871f601d9421a239035f1f9688bceb958c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d81ea3417804704ef4983646947fe871f601d9421a239035f1f9688bceb958c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d81ea3417804704ef4983646947fe871f601d9421a239035f1f9688bceb958c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf68adb8684fc81bbcc470da3efc2b4580118eb81bcfa4a30587f3eb5f4e9c44"
    sha256 cellar: :any_skip_relocation, monterey:       "bf68adb8684fc81bbcc470da3efc2b4580118eb81bcfa4a30587f3eb5f4e9c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf68adb8684fc81bbcc470da3efc2b4580118eb81bcfa4a30587f3eb5f4e9c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3eb50f55ae2248c7c16c93dbb2e0e2e57fb649f2644e163993d54795e414519"
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
