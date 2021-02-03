class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.7",
      revision: "5f5150730c644865a5867bf017100732f55811dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f5d9307157b0e52a03bb1696f6306b6d123141dd7924720b74bf420700f29603"
    sha256 cellar: :any_skip_relocation, catalina: "3401dbab4558251f9cd823be723ed84d4d2de9c583da28d6bb255f4b1f2a4757"
    sha256 cellar: :any_skip_relocation, mojave:   "cb47d6305cd3a8f3c877cd15ac0f0950fb75fc8359eaef70b45d599842088f00"
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
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
