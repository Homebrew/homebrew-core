class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v3.0.6",
      revision: "4a7004d045e2d8f5f90f9e8caaa5e44c013be9d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "95b1855240151d3abc65b47995c888cde8c5edfdd95736193ab753ea7f11a1ac"
    sha256 cellar: :any_skip_relocation, catalina: "92cf8a57cee116d5185c6f34d58c2ad06b514088855106bd6f9024618bd399db"
    sha256 cellar: :any_skip_relocation, mojave:   "e2bed94e7519871d90d15692e6f7bb6397ccc04996874b5553f0ff99c283e3bf"
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
