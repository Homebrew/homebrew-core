class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.11.1.tar.gz"
  sha256 "907651444f65274ddce0a41394ff7c06d4d12911a1eee885bde10ee334f1edd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8479e2d4279f507cbe9ab209a2efbe0cd384641885dc693f682d15f4d5c736ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8479e2d4279f507cbe9ab209a2efbe0cd384641885dc693f682d15f4d5c736ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8479e2d4279f507cbe9ab209a2efbe0cd384641885dc693f682d15f4d5c736ac"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2e07e96526b3d007b1ebacef66642b659ba426e5ef842b3c3ef3050f9284a3"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2e07e96526b3d007b1ebacef66642b659ba426e5ef842b3c3ef3050f9284a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2e07e96526b3d007b1ebacef66642b659ba426e5ef842b3c3ef3050f9284a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f49c98aeae6f5278ca4a2caa37f79e4475052687f5ec1ef681b3793561370db"
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
