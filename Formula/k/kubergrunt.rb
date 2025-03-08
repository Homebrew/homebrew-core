class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "f83b46064353936e6ae7def9aa1b70b50cbf3824349bc6bf695fdd5ab5003062"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c96220eff44efdcd56e306e0e4773c5c4c7f4f0df544f3054d70de375b5087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c96220eff44efdcd56e306e0e4773c5c4c7f4f0df544f3054d70de375b5087"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90c96220eff44efdcd56e306e0e4773c5c4c7f4f0df544f3054d70de375b5087"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eddc552281da829121e3b470eb4d008175dabe2d9d65d34fd3dd9dacc3e4c9f"
    sha256 cellar: :any_skip_relocation, ventura:       "6eddc552281da829121e3b470eb4d008175dabe2d9d65d34fd3dd9dacc3e4c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc8d72d487745108651d5770e6dcb68f1aef3c4378edeeec9a6fb4512ca38998"
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
