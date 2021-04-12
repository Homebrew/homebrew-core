class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.12.tar.gz"
  sha256 "adc0593bdbf4ea9ffaec932d6531701f5ba2b645381dd7ae393f33b915f545ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17a624db347a542269c28cab0c5ed0f1005d1a8556eed023d591ff5b80812fd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4005012d7273af928e0f3cfddde956de200591deb81836868642722faae0993b"
    sha256 cellar: :any_skip_relocation, catalina:      "39484ec40cb1b446a4a4f3f685cbd9813f952a5feda0d6433a7542c18af942e3"
    sha256 cellar: :any_skip_relocation, mojave:        "a8f2f2931a3cc02fde1112daafa55c2ac24bf5a6438cd21cff7a48bd260d9764"
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
