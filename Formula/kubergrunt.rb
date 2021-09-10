class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.9.tar.gz"
  sha256 "21075b55e11a61edf30da39e5e8231e1a5cbab2801d7cdb04254047992b8bebe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c0e012df5c53f24506f1e4361bc5b93619a42bbb0879e1d8631b9c2254886a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "811b0879fa61290127d5eb1eff4e546cf2cf3540159894ecf7e243565603b08f"
    sha256 cellar: :any_skip_relocation, catalina:      "cc37f68b03d6b7945dfb0d863ad822c886010b4a511b07fdf37c8c5eebe12d48"
    sha256 cellar: :any_skip_relocation, mojave:        "cb98fefd85daba817619259fcc09756c9afd9f6a4e4bc51e21f2ca1fb8776fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd75bc444dda357e7c86862a81553c651ccf76dcd511f14b9a66f0ff94b24269"
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
