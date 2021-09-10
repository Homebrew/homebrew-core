class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.9",
      revision: "e4f6bcb02f10bea5c76f2f91ff223b8a380b4557"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d793b915df94a12b1361a68dbdf17dee92a316953425c83e027808ae8db97efd"
    sha256 cellar: :any_skip_relocation, big_sur:       "92e1a838957c75a5d4357f52ee8f6f80f2d086598d2447df0e938f46b82050af"
    sha256 cellar: :any_skip_relocation, catalina:      "0e8fcf0cc099c4ea8466e7e7c0aa5bc56a0f95d91ce21c3caaa28fe86e6583bb"
    sha256 cellar: :any_skip_relocation, mojave:        "12be3fae5a52b38ff6c42086fc35dce870e40e974719836dd53a2865843257c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8067a5d6464507cbc5ec48ca0f4169c3a55d4466e484505a19854a769ef4472b"
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
