class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v3.1.1",
      revision: "a245fe67db56d2808fb78c6079d08404cbee91aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "935f060949a40f3e9a5be09c83ed2c48c239299ebf441f94655121be7b9ce04a"
    sha256 cellar: :any_skip_relocation, big_sur:       "46a8c3c14da676965fd14f1a937e86f1f5fa4660f8ecf66ac8515b4870e49431"
    sha256 cellar: :any_skip_relocation, catalina:      "bfd45fae4e0d4fe8277c830c03dcb37a71c60b001711332e69cfb87643403b70"
    sha256 cellar: :any_skip_relocation, mojave:        "838b5feeb20be1f02393e983b4770fecbeca3f84200906f7233c69531a5cec8c"
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
