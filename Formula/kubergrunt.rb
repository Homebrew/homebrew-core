class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.1.tar.gz"
  sha256 "116043e5353a26e3a008f57209dd6b0fc52d76d33eeee1b93c671b5b43718137"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bf557aa7b31ea6ca9723217a63d581dfde761b4d9e02a2eb58d4344d61ed210"
    sha256 cellar: :any_skip_relocation, big_sur:       "322cd875b445e043edbb9dfc32f76288369b2f88fa936e06a98742bc8a569d11"
    sha256 cellar: :any_skip_relocation, catalina:      "251293b1635b3aab783f2116eb26bf8e3d64f92aa4da2d88addaf27cae3c015e"
    sha256 cellar: :any_skip_relocation, mojave:        "3d501cdfb1409d49dd811686d6a17aa226acea2cca81455c40660d91e6f5880c"
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
