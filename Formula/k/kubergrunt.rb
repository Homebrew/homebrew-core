class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "133744dd91488579141b711f83c44d160cb46d4cb4d4bed12864c73a50efa36e"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58c66a030c2c17a30284885f3e5b06cf169d58973a70b9367da235e975bb777e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c02881620f7c2d2e5abab63e66563cd3b43b97935d8ad1535b11052707c25764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "885a87d1602f6cfd93c80f720d3289ecf6f73442a2ed42fdfa4611fc249df092"
    sha256 cellar: :any_skip_relocation, sonoma:         "2915d197754f74c0b3e27cda6578426dc03849331afb33aee4936985a432770b"
    sha256 cellar: :any_skip_relocation, ventura:        "1286ee0fd7bbdd2d9a6c72dd246aced77d0325ed759576206796b60db582fc56"
    sha256 cellar: :any_skip_relocation, monterey:       "ad13aec0e14c765177f9f2c13ee06bc71bf1ef059adab620c65406e05b7b0bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da26d9a71e31e4b9196296be9c6541f91f29ccabe05aa2cc6bb6302cc657fa3e"
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
