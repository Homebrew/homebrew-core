class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.4.tar.gz"
  sha256 "9caaa674558f540197eb9c5b092863cf7a82a8dead5916d2262fad2e07716e0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3087d75d8f1a2ee33aed57f49ee411ae868e023043b2076f84dd8b5a52ee1e83"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4b1b7d85830ce27b51f5459b0605ad2918e30d33522b45116f4213268c3afaf"
    sha256 cellar: :any_skip_relocation, catalina:      "685f262e8196fbd6000201b278334412f96fc64f0249c006e6c0097d1427fa6a"
    sha256 cellar: :any_skip_relocation, mojave:        "6fd2bc14347a2f90e940c6ecb72a396fbfbd595cfa2ed2d1d5fd3603155f520f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dacf81f1879c28e410eb785969317e204e3279acd21020d7c03be6b7572a5b5a"
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
