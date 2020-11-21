class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.8",
      revision: "310e099f82520030246a7c9d66f3efaadac9ade2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b213225ded18b2a16155f3eb3045aeb336a93a07c26d85f1bb7f808a89f77a1" => :big_sur
    sha256 "2eba8ecadaddd6e5031d596e3b3be120fef79a9388e5a72786dc8f034064b213" => :catalina
    sha256 "61a67e98c343a8de6542f269284d7309233e0a18e34e75db9086c87b2b7090a9" => :mojave
    sha256 "ed7cd091cce44d9a7cda03da29df688aa0b5c79fde69043ee4e4944d5afe897e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
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
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
