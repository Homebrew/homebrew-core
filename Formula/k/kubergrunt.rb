class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "09dfa47989d123bf255dac74022715ce48907af6a13c88dc52ef78932b52481c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e247027826e1df12ae7dcf045230464119efe75afc9d3fc462b89b8d42bdfe02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e247027826e1df12ae7dcf045230464119efe75afc9d3fc462b89b8d42bdfe02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e247027826e1df12ae7dcf045230464119efe75afc9d3fc462b89b8d42bdfe02"
    sha256 cellar: :any_skip_relocation, sonoma:        "d46d7e5445445515f9dc30d1b56128fd29f6b64e1d15eea59449cec974c0690d"
    sha256 cellar: :any_skip_relocation, ventura:       "d46d7e5445445515f9dc30d1b56128fd29f6b64e1d15eea59449cec974c0690d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f941bc0f5b7332db3c08502d8cba66fef71089570e6f9e33c26f64fdeae50cc2"
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
