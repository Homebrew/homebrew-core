class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.1.tar.gz"
  sha256 "116043e5353a26e3a008f57209dd6b0fc52d76d33eeee1b93c671b5b43718137"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03fc971c4895ea40964ee5e8c2fd6e321bc516d2b143741cdb66b086178c1ca6"
    sha256 cellar: :any_skip_relocation, big_sur:       "0399649037fe94e1a8d84e3e560f3e557b678dc6a466dca0878a8b9141dc526b"
    sha256 cellar: :any_skip_relocation, catalina:      "80866a3fed8dcf7c81a974ae408cf2d66e3911edd7ecbfb6b67545a2c45e4c7f"
    sha256 cellar: :any_skip_relocation, mojave:        "15ab134be6b6005ac0b0a48d48cd3521e57ca9b4a55278353e3dd70adc1b5e1b"
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
