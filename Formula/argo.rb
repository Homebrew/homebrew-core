class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.2",
      revision: "7868e723704bcfe1b943bc076c2e0b83777d6267"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dea33d13d1a112f61c66394f7927a41a463275581d6c6a7357664af032bac033" => :big_sur
    sha256 "418962f6ce91690d993eb22290eae2826b2ed8961c2a0f8271e38d8e7bd9be01" => :catalina
    sha256 "45d215d408dd5dcbe2cc61197d966bae9a628492ec7e5053a535ce8ed4760746" => :mojave
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
