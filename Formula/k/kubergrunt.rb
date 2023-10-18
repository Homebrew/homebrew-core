class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.12.1.tar.gz"
  sha256 "056530d2b9fa43cc7807d5a924df78b31c9d2f7da2e1353eef514452179c01db"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7164165dbdbdce16788753bbe0cf6ad2fea6a7025eee2689382bd04d48f898b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a88eeb8d36e0a2213fe46f6df3c09fb77be5ca81cec7c4349317356a35d6b2bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a88eeb8d36e0a2213fe46f6df3c09fb77be5ca81cec7c4349317356a35d6b2bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a88eeb8d36e0a2213fe46f6df3c09fb77be5ca81cec7c4349317356a35d6b2bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "89a5e95f37f8fed819201363c5208df2aa1195a4583e345938239e3c25d510f0"
    sha256 cellar: :any_skip_relocation, ventura:        "84788222382ad3571c460cd613611bd87450747acfe3d5feb3ccd503d41763f7"
    sha256 cellar: :any_skip_relocation, monterey:       "84788222382ad3571c460cd613611bd87450747acfe3d5feb3ccd503d41763f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "84788222382ad3571c460cd613611bd87450747acfe3d5feb3ccd503d41763f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb8f2a193ef850e9e768089d26d29ba3e7eb2a45fc16a3c6e3da6a61aad830e"
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
