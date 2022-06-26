class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.9.1.tar.gz"
  sha256 "8bc05d05ffb61af96c00823ecc1eacc0fdd33de985bfc2501baf0ea829762367"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28253f592a18170eac8bc754c4a41f2cf76481063d760156afa7e81112dea2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b40b0c7931cbe6e14f64fa1674ed4d3029b9a6facb05e4fa6433b43dbf8404e7"
    sha256 cellar: :any_skip_relocation, monterey:       "680210953d896ebd68457f2078b58500ea5eb92f95f2f8fb0820573c4b64f399"
    sha256 cellar: :any_skip_relocation, big_sur:        "401e869549b868b8681f80c5c80fa0a35574e2e81d38eb7ec70c1b35480bacab"
    sha256 cellar: :any_skip_relocation, catalina:       "c303f8d436e03fb99339642fac47c2d8d5bfa6eb9db61486859383b50a8e9f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc886ee8abb2f8e2a104e43874c4bd281f50cff4c0ef2e573ff129534d9f171"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end
