class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "a733fad8d1d4ddfb80be59dbe638aceaaa74395da3825aa315228de58583e362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dddbb1efc3378142de8d59ef90562a5aa51807e64056377d2e9d1ac59c44fe75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dddbb1efc3378142de8d59ef90562a5aa51807e64056377d2e9d1ac59c44fe75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dddbb1efc3378142de8d59ef90562a5aa51807e64056377d2e9d1ac59c44fe75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dddbb1efc3378142de8d59ef90562a5aa51807e64056377d2e9d1ac59c44fe75"
    sha256 cellar: :any_skip_relocation, sonoma:         "c43f1c43c2644f567b5cdf11bfc834cd221ee7485a73de9f3ad9658936adec06"
    sha256 cellar: :any_skip_relocation, ventura:        "c43f1c43c2644f567b5cdf11bfc834cd221ee7485a73de9f3ad9658936adec06"
    sha256 cellar: :any_skip_relocation, monterey:       "c43f1c43c2644f567b5cdf11bfc834cd221ee7485a73de9f3ad9658936adec06"
    sha256 cellar: :any_skip_relocation, big_sur:        "c43f1c43c2644f567b5cdf11bfc834cd221ee7485a73de9f3ad9658936adec06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4d8a841b4dab7c297af977063e61f5e6637c27ebfe25699da54e3df5b58157"
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
