class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "e2acf5728d71042218555e47db11cc2d8390e1678c4599ac2a6996e7dd629a5c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2412fe62c8bf8d416bc173aeeb6264eb324be1e65ae4ecfa36108033df49af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2412fe62c8bf8d416bc173aeeb6264eb324be1e65ae4ecfa36108033df49af3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2412fe62c8bf8d416bc173aeeb6264eb324be1e65ae4ecfa36108033df49af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2412fe62c8bf8d416bc173aeeb6264eb324be1e65ae4ecfa36108033df49af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e34b79897c6c9ad7eeb097b242d338241113ff5eb6070c9df65f03c45142c0"
    sha256 cellar: :any_skip_relocation, ventura:       "02e34b79897c6c9ad7eeb097b242d338241113ff5eb6070c9df65f03c45142c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db340827e03ad3467ad33e6e15f28b500c573ef04428e1929ca7254e609ff3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc160bc31408aff9e91c1d31dc272c4410f8b7ec876dbcefd1ccf4649e5d6d6"
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
