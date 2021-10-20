class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.0",
      revision: "a29495bb5b4aedcbd8fa7bc433c1bccbc374e6d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d3f1d7e5120c83b3431a59c9eef5b1e7a3992f6bcf243d4de9f3d9e3adc72a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0976e041a58079e022d35b4c02ee868ec9f603956f8d37e19dc776099ba25abe"
    sha256 cellar: :any_skip_relocation, catalina:      "34f8d2d0890e013dc0e692f1fa5726b82804a72cd2721c4e6ae0c649e21d3525"
    sha256 cellar: :any_skip_relocation, mojave:        "42304035d43788460c4020f66ea27c3f49f04a6f25df16e0de71ca05cf6f78d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eacf18e79519ac8cb35d3f96a3f62ff9b0f1608368cfff21d39d20d18dd2c0c"
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
