class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.0.3.tar.gz"
  sha256 "4f5de8beb0cef1393620dfe1b3e9aa2424b190e6725bfdd4c343b1dd8ba0b631"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24435b62150e63f018eeee6a574791f44e0ab39751e3611fec3ad6f51d194269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10c36e74fe274cfc99eed7134132acd57119f6c07cd06e1710f66a922151f8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "64bddbd96a87db0cdd9b910d1e79df65d2fb36780b0f60db695eaf1f7e84aac0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6ecaa47dafb2b3600d8451851b526a05ed3990c6c018214f18b217f44155c90"
    sha256 cellar: :any_skip_relocation, catalina:       "c83ed9625268863adc94c7e0f1318136ff305c4b7cd08a67c195f1d24c1ef3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a69624af5aaec13233424a5d9f3b90afe1df96dc0a22c4116501a775a5db4a"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
