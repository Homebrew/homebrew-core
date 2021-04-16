class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.12.tar.gz"
  sha256 "adc0593bdbf4ea9ffaec932d6531701f5ba2b645381dd7ae393f33b915f545ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edd18788b38bbb16772fb0cf2625e3e56476f1c326d44edf7dd11ba0f8455863"
    sha256 cellar: :any_skip_relocation, big_sur:       "86158daae2c928fb5d6510f0e730db761213ac100f90650564be033e5082c133"
    sha256 cellar: :any_skip_relocation, catalina:      "2998e0daeb064a3311697d1245a8cd119dd1e7ad5b57614ebd88576340fde842"
    sha256 cellar: :any_skip_relocation, mojave:        "b23c7cc079aa26b7480da6e659a6542928021a0143800e3ec3c2b7c6c9c1165d"
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
