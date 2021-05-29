class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.0.tar.gz"
  sha256 "075979f237f97914d8f662fe53dda5e87a95ce8f13d06b813f506d3ee2f4a04a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d47692aefb224cd160018a3fdc2f72f856280f925971f3da6d073b99d238a57"
    sha256 cellar: :any_skip_relocation, big_sur:       "23b6314aaf3a4449c9b0910baaba0194176a6250d475e239a3eb50ef0b0a9bae"
    sha256 cellar: :any_skip_relocation, catalina:      "6ef2f1b6fde585a79dee304eefdf2dd62c96840e22d1c111f4631ebfad1d7b3d"
    sha256 cellar: :any_skip_relocation, mojave:        "d645ff330986be6f5753a0d1b0b4f98c884323dfac343fa6047a723b7780b7c2"
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
