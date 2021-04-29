class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.14.tar.gz"
  sha256 "eec3201c08d9b5056968d796d63a6f40b93d0ad44e1fb96790c078c123b20ac0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9979f90ceff491e94e5d9cb7a771ee4a3b4fa7f7bfe1e7c9fa1d19642e92314c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7486b82ffd5b1576fe8274f31ae9af58f3aeb2bd1ef15b648a765a873c54c82d"
    sha256 cellar: :any_skip_relocation, catalina:      "9ef3ddddadee278b3cd54e974d8efddca540199c9f9044f7256b1a423a1db1fe"
    sha256 cellar: :any_skip_relocation, mojave:        "5b48bf74340107f024b2aa4049859c2b0954a85a7b175cddf1f0ae642ab1e855"
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
