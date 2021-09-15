class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.11",
      revision: "665c08d2906f1bb15fdd8c2f21e6877923e0394b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80c8ff88580f98b78e28cb79f7658918bf8a08958dd1974c682c68e6dcb8d8de"
    sha256 cellar: :any_skip_relocation, big_sur:       "08763ccb56f3e36f310f2da13459151fc08fefde543fef0a9ced5456255d07fb"
    sha256 cellar: :any_skip_relocation, catalina:      "577ac6385fa44a076716018f4cf76728ce1a632e67054f76cdde7fb70f80b25d"
    sha256 cellar: :any_skip_relocation, mojave:        "be46c18a5d87d4eee9ba951e731eddf3ab82dca548fed560ed93c67b22be4e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9122703558bcdaacd6f1e2cd9d617b14294e286a35c8c9d7b87ac4bd31f16618"
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
