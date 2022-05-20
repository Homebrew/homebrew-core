class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.9.0.tar.gz"
  sha256 "9616fb78bb7a47788ababb4a6a03a4045619cc82772f0415d9ebd41254a5cb6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4927506439c7c6c5e5b4eeb1213f3570d96aec7a008773926a0be7dc9b40ce6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5065390fccb9abd280c710b6755855604303f69e793618d143537b29ca72255b"
    sha256 cellar: :any_skip_relocation, monterey:       "47cd63be178269a1819b9bf29c69843e3123dc3630ffb20868f7795ada10ee95"
    sha256 cellar: :any_skip_relocation, big_sur:        "06401824b1d5d034b1b1c27c3a471deec712ea97d14e2dd6601c2152c1274451"
    sha256 cellar: :any_skip_relocation, catalina:       "fd8eca5225bd566f91805e6ebba3702d66593e80eed2c957d4651eb8c68626e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759ff120a5f19a2027c6b013b645130682b4653bab07e4257e7a8cf2f383e9ba"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
