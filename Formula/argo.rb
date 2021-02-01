class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.7",
      revision: "5f5150730c644865a5867bf017100732f55811dd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fbebab4b4436e76affc654179f0f3b7ff640fa84906cedd2f999bbf88a56ae1" => :big_sur
    sha256 "b701d0e84248e28a70d048e4ef60fb3986f9ac02c3938638cc081f5918475dfd" => :catalina
    sha256 "51d317dadc17c2a52722d1eda694615a4984b3de374f3a5e73a0f430d8b631f9" => :mojave
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
