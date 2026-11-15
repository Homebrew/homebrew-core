class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "7199de22f0e638ddd33a4fa1d62f0486b1c3812a3da4f9f1c9e12542de6b7d38"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a13c8fcad11d51a882e4f087a168e5064d3d8b938608df1aa620be374c9ff67b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a13c8fcad11d51a882e4f087a168e5064d3d8b938608df1aa620be374c9ff67b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a13c8fcad11d51a882e4f087a168e5064d3d8b938608df1aa620be374c9ff67b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "284f6cfb48cd1bb11b0506a59bf68ae0ea73ce947ba063447bde6dd6d1153309"
    sha256 cellar: :any,                 x86_64_linux:      "ef45fedb7add395cec5ee1160aeb7bc21bb2ff7af3c48121385e015c2d64ef43"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}"), "./cmd"
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
