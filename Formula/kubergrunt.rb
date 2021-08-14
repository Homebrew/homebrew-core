class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.4.tar.gz"
  sha256 "9caaa674558f540197eb9c5b092863cf7a82a8dead5916d2262fad2e07716e0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "005524e1c17f99a07c91b2bda1f13266eed7bc2a167b8fe6568aef71554b2fa4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1da34eebf98239237ed7f1eab7e9f769758316d9ee337cecf30acd45d4b1cf1"
    sha256 cellar: :any_skip_relocation, catalina:      "2fffbd0d83932a9a536236a4f2543b9282472914c9ce87ca42636adeb5880694"
    sha256 cellar: :any_skip_relocation, mojave:        "7e9fc035fd941550cf1df3b4a7e2271779b2fa8bfc8b7aa42ecc9cb77ff2cf5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9c5846662b93567a71b7b7137de8a0b6c3727e8376661a350747743bafdacd"
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
