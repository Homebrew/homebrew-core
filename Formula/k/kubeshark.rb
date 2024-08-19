class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.77.tar.gz"
  sha256 "0eab4d43de4f83a0b6be17f5350a4b29d909b5b8f91c5a53c8229573db0ce8f1"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a59b0dfdbd030a72ed130e04019efa07d338d74d56b0344a48a0f2e0eb49f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e654eee26f8ff11af7b4b62502595cda313acf9f4af89abf5c5978d493b4d243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ac332bc89ba15cbe987209933f8deed8f558766e957ecdfdc2e5212f7bd60b"
    sha256 cellar: :any_skip_relocation, sonoma:         "dee2ef76db7c205b818314a7892eddaa57fccc919716fcae83ebd7175ddf6cde"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6d74169ab5f2025355ec6f6f4cf35e965c37ed6ede889c6e3e1bcbf114251c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce47ff420592bc6c6268030da8c47a66a3b48e2f39be78227f9952cd6fed128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de073e18685f8ef6534b7efa069b86a0dbc6e5ec875b1bce71f1e49cb43ffdb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
