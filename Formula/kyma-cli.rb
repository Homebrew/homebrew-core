class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.6.tar.gz"
  sha256 "dbe03ebb6c5375f6ee067375eb7cae67afab43fa48e874a286b5afcdd9daeed9"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35d3209e7ce5152fdf20b8f3db11d2f0ac7d32ff3c9b8682e5ee11a3d01ec2f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "643ae5b5554110a73cb97407d85c1ead268253e806087e3e545d3c0d428594ea"
    sha256 cellar: :any_skip_relocation, catalina:      "03564fa556013ff179a4be57dfabab3af81505e2bc253d638232092cd6c713ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e1b4948dfc419631f6732210121fda1fd2727b64d2b2f34e321e8afe8d9e39"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
