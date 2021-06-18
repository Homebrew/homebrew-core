class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.2.tar.gz"
  sha256 "0e001d8e455b7c6b54d76c6873e269ac80c03cc57d63266f907d1f3d3ed23354"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dec81c9f14ef44c4cd2b775cc5c2227cc914b4468f5b73fc7ad99a3635beca87"
    sha256 cellar: :any_skip_relocation, big_sur:       "02f1969ae1a18bc5dd73d4c9be832d367e7ea78f9055aac2384d606b04384b06"
    sha256 cellar: :any_skip_relocation, catalina:      "7e9b64b7e3bd5518ba9320ba2fd85c4a05872d99df7753e019d15c562a31d6c2"
    sha256 cellar: :any_skip_relocation, mojave:        "623c9eee2bf0fa95ccb28ad690761bfc6b4ef2061df064b207aa250393a881dd"
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
