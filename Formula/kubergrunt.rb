class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.9.3.tar.gz"
  sha256 "d3ab0734a6e3d0a8bcf2d174fd17d469b35441fe80d5ab56d372c56320e1b2fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c505aa037c10e4333f7fdeb791cab0a5ac27cc7e35a1f0f977ed7efd6670628"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38bb8a8a6a6d0630df4de863fbf919f267fd563082c40549e7c21a14ce7f054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4bebdfb4f05a6fa3777161d5f8674a8133867716b8172e6062c94a1ef35ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "56d3fe15d15044e6191292fda775e93d710a8206e647498a701daabcb83b08f0"
    sha256 cellar: :any_skip_relocation, monterey:       "db5d9aa7ba525edf7c0fe9f348f7145707a842a98d6b262103c3facc840e55bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cccf05b4a90f2e60d5f0d758a67f98fe9274842f255792b90e743ea5843efce1"
    sha256 cellar: :any_skip_relocation, catalina:       "fb296958781f291e97e1b96e457415277feecee5522b953f380e47271265d64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0c5491615d82a8284fdd63e999711351f2647aceeb925b1c29ab2874a89edc"
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
