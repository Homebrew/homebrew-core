class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.2",
      revision: "8897fff15776f31fbd7f65bbee4f93b2101110f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c41053d3a367629aa9685145a608908c62f8ddda930bd1d02ada27a069444ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac8899624efd6b3e1b8c9a886a8f2ad7fd8dcaa7361c3473ec24601f8ccbfcb7"
    sha256 cellar: :any_skip_relocation, catalina:      "71eb0c7a01cc34e325e379d1851ce0c6e7ee65c785c4174964305061e56f3a8b"
    sha256 cellar: :any_skip_relocation, mojave:        "8ff152f089385cc8a91ae043816f58c70e6528fb110ea48c881499b5085dc3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5661c21bcf2def86cfb38909de412f5426cbb943a5ab3bcf4b07d13d226d60"
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
