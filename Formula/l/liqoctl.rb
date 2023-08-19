class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ea350df8e650bab3c4b9250edbb9e97233f96b4e8e7291655b5993d0fbbfba7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "043d3133d552127d6a13ad12a4750195c7c0b8401eace8d32b1728c563085d37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "043d3133d552127d6a13ad12a4750195c7c0b8401eace8d32b1728c563085d37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "043d3133d552127d6a13ad12a4750195c7c0b8401eace8d32b1728c563085d37"
    sha256 cellar: :any_skip_relocation, ventura:        "7b93138456257acf9c0692945215b8b11712ad33be9f16c30c054d0dff5d2ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "7b93138456257acf9c0692945215b8b11712ad33be9f16c30c054d0dff5d2ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b93138456257acf9c0692945215b8b11712ad33be9f16c30c054d0dff5d2ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d330ee67d99972adabf8e08cbb95f48abf8657bc7692558ce9247733c481c2d"
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
