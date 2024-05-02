class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "101084e55d1f8e23ab7782666a2cbab51c66b4296f05dda3861848602662063d"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21367d24edb3f38c2a39d78ca508ec2c2fbc26246693cddd55a8175af8d095c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17702980d2f3d295112194fa1247aa334c049219f92d7c3c1800116374658ca4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf1c1d7ddf8dabb80307c6a1aa855a21619791202d3cf2232ec0fbc74cb6710"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d987308e06719e446c1a72303897a2c66a9061aa27335d59f119e16b5960d79"
    sha256 cellar: :any_skip_relocation, ventura:        "3e43eebfb413469a97f2839ac68930d3c83f0f627879bdc3003d5be31c9c72f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a72574669f80b0277f3bc59c1f134c9aa29badc46976424483837650c5bfa025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed40449a816509068fd40002f8ba8ebb9be882d0db0fffc2e4bd6645f95404a"
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
