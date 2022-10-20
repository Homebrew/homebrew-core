class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "f4ed993012d2315080a758e683ebe5f36eff6f389b2e68b2857f380bf1049228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2029554bca65b3e6af4b3e1876eeb86858b6ced6b08bfc14df228068c4c852c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2029554bca65b3e6af4b3e1876eeb86858b6ced6b08bfc14df228068c4c852c1"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc1bebc4b9f5f2e86227fb48406d674e7769c43f75c648dece31f8679946eac"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fc1bebc4b9f5f2e86227fb48406d674e7769c43f75c648dece31f8679946eac"
    sha256 cellar: :any_skip_relocation, catalina:       "1fc1bebc4b9f5f2e86227fb48406d674e7769c43f75c648dece31f8679946eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64309ad6fc1c7c52f82eb2437538564009bf5d197be2b84bcc69d7deafd6137"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
