class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.5",
      revision: "53f022c3f740b5a8636d74873462011702403e42"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4896078ec42a384bcaf6aaa4550d3ade42705f9f00b2b9d54621d761af2a1e8a" => :big_sur
    sha256 "00a3e7be8c6d89c5b83b845c898d19f36dac52be482c6a29cf87710c5dd38469" => :catalina
    sha256 "1786b2764ea195d453a4edf1f534d85c753a676a029652f33c0912a093c2db3e" => :mojave
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
