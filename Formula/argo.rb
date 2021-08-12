class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.3",
      revision: "9337abb002d3c505ca45c5fd2e25447acd80a108"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1899578b3cf198545f8987b37792183026e6447a978500dc838d7988aeda7133"
    sha256 cellar: :any_skip_relocation, big_sur:       "b28e8456524d4798dd68ce6b88458ce4d580cf958f8b3eb10c23583f17de2a1a"
    sha256 cellar: :any_skip_relocation, catalina:      "b966f16eda2b1da00cfb0f31e2bf53898e07c295d8e33ba820e3785412da2138"
    sha256 cellar: :any_skip_relocation, mojave:        "e47b7d5c5c6220f22fd485abb0dd6956f8b7d6ec154ef21cba7d2c28bfb7d20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b414a24394ddeee506984fe7533a089b761e7c6df2610f46200a7ee605bf33"
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
