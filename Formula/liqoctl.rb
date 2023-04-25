class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "adbea0273864b571e449b8baec7d93558a0b11dcc84b95028b97f19ff42369e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00677be5e22174a920df93a03238428932c9de765b205efc42e4d4c24f38f05c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c409c9918a3d88cc52c9eec35649237bb4657a4c3b3d7d1a0e8707c06fafd576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00677be5e22174a920df93a03238428932c9de765b205efc42e4d4c24f38f05c"
    sha256 cellar: :any_skip_relocation, ventura:        "9d9c1f5c5d497289c7f5efef091a61188653127419e937f8148efaf8437a5697"
    sha256 cellar: :any_skip_relocation, monterey:       "9d9c1f5c5d497289c7f5efef091a61188653127419e937f8148efaf8437a5697"
    sha256 cellar: :any_skip_relocation, big_sur:        "2815e67b4ae8592bca6087ca3c40f2577b966a8021e6fd46167db2e3a05b5fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "507f0f11df425dce8f9cdb63b75c4900c910aa41279d0f639cd92f03b894d8a1"
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
