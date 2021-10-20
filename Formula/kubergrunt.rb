class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.10.tar.gz"
  sha256 "e474e97bf344a1e547a7b04bf99c0fe63afe5a72a6d08c7d2e86803a41007ed3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "faaa313e8d0657196dac651629f00d050665dba11dd550399d6c601743518f63"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3dd08aa250aeaac07f7b37fa8528c0afba674fc99ffe220d900a62c7e2aabbc"
    sha256 cellar: :any_skip_relocation, catalina:      "ad163f56ac0a42756af0efd81f25cd1e1c5786fb69c80763d610bb09ccf86d6b"
    sha256 cellar: :any_skip_relocation, mojave:        "9f644f15583e5e6cdf25160c637155edde3326039a5b1d18e010dea768d28d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "205069ac85b982c4e35ab1c01440653edaca209b11c105879569b5daec5ca942"
  end

  depends_on "go" => :build

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
