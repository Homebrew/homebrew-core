class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.10.1.tar.gz"
  sha256 "d834aa9dc6fc7406d9de01b00e6540ad740f660203b1fec1cfa2c108a2383f0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68de168301558f104224605228fbd5edf0d5757dcc294b7e01669a5f8517021e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02600fbb109c0d5838020251aef0d5b59b27de3e26755d305e17ff5f99f41801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4c1837a3a0497f1ca267f73ed3a93c3fe5443e5173370beada4d8ec58f07412"
    sha256 cellar: :any_skip_relocation, ventura:        "bdbe85cdd68adfc1c1af55ba11489bdbd2e69f3a78187c1016ad143bd70bce95"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1b3f37a8c1493df03166fe043ff8a19c8e3f83763d86aaf952548f1cb02f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1717ba3130f0c499c46863f9d62474bc78021b9a1eada8b1d5c6a0b9cd876539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad6b6e61f28758728c4e1ae465770c5a9e4551a353559067970aeda46c4772c"
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
