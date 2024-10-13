class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f4c7314d83c1385128c4ce917df5c3c0f4cdd44ab6e2032dc7149021c9a32bb0"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6dcabec9c600535292967d60e35f5b55983e8df395b080006058a9b885949f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e77f63974d3cc31671f6151619ac2ec0a8478fa8d2fa1850d85ade42263f026"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e77f63974d3cc31671f6151619ac2ec0a8478fa8d2fa1850d85ade42263f026"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e77f63974d3cc31671f6151619ac2ec0a8478fa8d2fa1850d85ade42263f026"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f69fce621902939d28afee49363999b1e4345c43ed51e2681b22e83bcab1b21"
    sha256 cellar: :any_skip_relocation, ventura:        "2f69fce621902939d28afee49363999b1e4345c43ed51e2681b22e83bcab1b21"
    sha256 cellar: :any_skip_relocation, monterey:       "2f69fce621902939d28afee49363999b1e4345c43ed51e2681b22e83bcab1b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2189c9fe21007b7254f00070eb5e2fb2d356032f9e3bf0b84607841c3bec8f8a"
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
