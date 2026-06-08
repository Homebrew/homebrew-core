class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0bc4d67db238b974bb2a80b4786beb8ff3c38b748b3e10448c5f0174c7ead488"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1c2def529c9a4c7077b49de33fa173a5178fc74310a7bd91fe43c89d939413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1c2def529c9a4c7077b49de33fa173a5178fc74310a7bd91fe43c89d939413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f1c2def529c9a4c7077b49de33fa173a5178fc74310a7bd91fe43c89d939413"
    sha256 cellar: :any_skip_relocation, sonoma:        "882c7940ab2db99842727401de7c2f07d08b407eb7018b49d761fd09a50b09ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec4dbf35e1ef6fa3afd74291c1b140498d90b2e1b3ca043f06a76be7e758b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d71c4ea2bdbceee1b90cc2b869da0511b722ba45187e11a3d5f50f14db1c4ff"
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
