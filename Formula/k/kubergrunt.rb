class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "6f8c2130687eb0d54bc5fdf33bb6f639fa888f73a03bafa54e67d1f7f3af6d68"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/kubergrunt.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b68cb058c9194b0a68f660488e279ab3fe49de3b40a2de0eb3a3d36a9f5e3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b68cb058c9194b0a68f660488e279ab3fe49de3b40a2de0eb3a3d36a9f5e3f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b68cb058c9194b0a68f660488e279ab3fe49de3b40a2de0eb3a3d36a9f5e3f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6019901c4d70272f2bf5434321d205f26392197e6d903a638f3fa597352f742a"
    sha256 cellar: :any_skip_relocation, ventura:       "6019901c4d70272f2bf5434321d205f26392197e6d903a638f3fa597352f742a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5791805883370a0ac1015f2a277d318f479ebf32050222a16e718a18dd352a"
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
