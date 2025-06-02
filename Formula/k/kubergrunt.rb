class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "5945d96546464061503cfe4033f12b23140c50fa01f696fdfb2e26c634dbdb37"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81891380ce3a7234b8de9560a87351bd83944484669c95eec8216d038a0f6210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81891380ce3a7234b8de9560a87351bd83944484669c95eec8216d038a0f6210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81891380ce3a7234b8de9560a87351bd83944484669c95eec8216d038a0f6210"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1142ebf81f673bc9e0c55cfa8c86c4b4a9232ff0a7e12b1b02ec097fcf75940"
    sha256 cellar: :any_skip_relocation, ventura:       "d1142ebf81f673bc9e0c55cfa8c86c4b4a9232ff0a7e12b1b02ec097fcf75940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87686a336af3a417ff05ed4c12cfd1ffac42e3e657750897d29e05f7ea785e3e"
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
