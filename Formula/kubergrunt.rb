class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.10.2.tar.gz"
  sha256 "837442e40827831599429f2006f46cab3b48e2e4fad96ad887a2a2a6443bceb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed49cb958f8b0f520b9b91c33b2bbff29965e3f65ef5c614523ace2736ca42dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0d9ae276ff773154f1a3a33c2b3678381fd4297e420d80dd8694d6c88381a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6117deff0212637993d9f34dde5e385d373b6de370cbaa2ee2c91d9692f5e5ff"
    sha256 cellar: :any_skip_relocation, ventura:        "ccc7f1710bf5a093bff998f12aae87236554f585463457a272222f754283edda"
    sha256 cellar: :any_skip_relocation, monterey:       "95fef3654406f148a7cbfc0aa8dd125784f335aaadd23396d5fbbff5a677291d"
    sha256 cellar: :any_skip_relocation, big_sur:        "97b4ce36a97f348cb91ef8a5d22223ae7fccf0945f7a4ad2cdc19648293300e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4decff027924f2dac9e44f400a5cdbf6ba538025988eccf5bfc5a904e87dd990"
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
