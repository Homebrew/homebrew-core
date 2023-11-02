class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "26f219f634b0f16a1d0aafd6c090cc264dffc1cb5aa2da2f64c6698af04d8748"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c883f5fc3ef2b9048c5d3946dd8a2e7f6aa66a580488a79f79ac0d9fbc842b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c883f5fc3ef2b9048c5d3946dd8a2e7f6aa66a580488a79f79ac0d9fbc842b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1c883f5fc3ef2b9048c5d3946dd8a2e7f6aa66a580488a79f79ac0d9fbc842b"
    sha256 cellar: :any_skip_relocation, sonoma:         "57de6474db305bce95c4bce1e142805351033fc7601d09043d57c751bf5b5c09"
    sha256 cellar: :any_skip_relocation, ventura:        "57de6474db305bce95c4bce1e142805351033fc7601d09043d57c751bf5b5c09"
    sha256 cellar: :any_skip_relocation, monterey:       "57de6474db305bce95c4bce1e142805351033fc7601d09043d57c751bf5b5c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae35cd96b2d80209ea752119fde6fdd1bb07ec7deca37ae21593f0d057028e9d"
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
