class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.6",
      revision: "14e1278572b28d8b1854858ce7de355ce60199c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18fd9dae34ed23db2d3853fd3f97497b44cb07ae18bfb6d21a7305a7ab01a08a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bff2e001476bdbb67eac76dcbf70cbc75853cab14162b0c10e34c1a09ed8f336"
    sha256 cellar: :any_skip_relocation, catalina:      "2d365dc50a7cfde7f756de6caba1f3a31f6863ac07ebd1ef12c43449cda682e7"
    sha256 cellar: :any_skip_relocation, mojave:        "9212cc2a42f93a0b9b13f28cdc6a778b7ab97d174663a407906df1b4dc0d284f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c96cba3cd8d0aaee1844a47c918319126c7fa3cfd90b4512146fb81ced0947"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    output = Utils.safe_popen_read("#{bin}/argo", "completion", "bash")
    (bash_completion/"argo").write output
    output = Utils.safe_popen_read("#{bin}/argo", "completion", "zsh")
    (zsh_completion/"_argo").write output
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
