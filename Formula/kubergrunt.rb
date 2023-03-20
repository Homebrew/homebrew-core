class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.10.2.tar.gz"
  sha256 "837442e40827831599429f2006f46cab3b48e2e4fad96ad887a2a2a6443bceb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5881d734fcd146a5e38c7f9b46f93bf0b43f9b11e6d14ff6c28f3133f36d82a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131537fab553c8445633ecf4f8e65ef0421eaaabb8371e7add86ae4ae099e9ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e0b5ede1490ce0e0a76ad53fdc7dc6af6328c2c6ede58e211952301a8a9767a"
    sha256 cellar: :any_skip_relocation, ventura:        "db5086501e719769345ccfd79226a3579c28ab5258531c0466bee4cb51a730e5"
    sha256 cellar: :any_skip_relocation, monterey:       "6925c607220df36e491eeaf3f5d666eaea6f1e41c05661a76b7b03fe6b8b4a19"
    sha256 cellar: :any_skip_relocation, big_sur:        "37daf452e0833dd0238dec82b0e418c6ef9fc8531251e3e912252b737a4b6843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba45cba8901ba83eef1bff7d00a13500d889e2900ed876a6197b6b50970d61b"
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
