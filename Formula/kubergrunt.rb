class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.15.tar.gz"
  sha256 "04aa7721a3186f9631e4edd26662c687dc0fbaec5bc64af598c0d3dd411066b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd8c02fd447b33a3879a68d1c1eb4b80b056a510a15ff0d6a3dc851ee47268c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "50867a75ffc0b3d1447a5f69a5a7e9d828b10294fbbd3b6ebd7c82ce01752663"
    sha256 cellar: :any_skip_relocation, catalina:      "846c49988df572e46fb6ede7934e5271bc0e22529cc0c89702ed6ea5453e4383"
    sha256 cellar: :any_skip_relocation, mojave:        "651a776ade6e7139f1df1193f0e89ee66bfd8c7bb136e1bbca13ce49cd853836"
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
