class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.11.3.tar.gz"
  sha256 "71dfcaf98c933ae8c343fa7dc8095b9c9e216cf4e64d15e1d6c1a087814576ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a4a473c485b9764ee800e4f846c5f49a8b3d39b1eef8677a363b205f1739c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4a473c485b9764ee800e4f846c5f49a8b3d39b1eef8677a363b205f1739c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4a473c485b9764ee800e4f846c5f49a8b3d39b1eef8677a363b205f1739c93"
    sha256 cellar: :any_skip_relocation, ventura:        "f97ef226664975bf5c5e6edb9d80fbb71ec70195152bf3d77cc31ff965d03670"
    sha256 cellar: :any_skip_relocation, monterey:       "f97ef226664975bf5c5e6edb9d80fbb71ec70195152bf3d77cc31ff965d03670"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97ef226664975bf5c5e6edb9d80fbb71ec70195152bf3d77cc31ff965d03670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f420ff49ebfe2a38d2dbf20bf94987cf8f89b093d3618db043d86e83ac3c53c1"
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
