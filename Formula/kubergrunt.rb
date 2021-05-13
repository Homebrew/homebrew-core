class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.16.tar.gz"
  sha256 "3b1955363718f22c3612f323f1b646351a896f62fc5a7829eaab7d13b776b2f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2762460224fd73f87da9c32aafd9ba79914416afb1f0e58f3af532ab416488a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7e6f3865155e564373dcb6c55bb64a86926afe7954b3da532613f2873fb76f1"
    sha256 cellar: :any_skip_relocation, catalina:      "229b3ff21746a835baddadaddd5a8caa0f35e429bfa770de5a14dbdbff6de0c9"
    sha256 cellar: :any_skip_relocation, mojave:        "431c1f11b79f87cf1c5385aa36969ef5a253c3809dcc86541cc45f34ab2ba05e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.VERSION=v#{version}", "./cmd"
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
