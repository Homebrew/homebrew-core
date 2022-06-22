class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.7",
      revision: "479763c04036db98cd1e9a7a4fc0cc932affb8bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bdbaf9731e3c28546f424e70bde8304f8cd8909cf7e2504ab71c246bac99d6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d28ca0ce96fe5b601760faf03567ac742fb2e8fe725e65b49fe55199fd6bc1ff"
    sha256 cellar: :any_skip_relocation, monterey:       "8676dd21292c848a913c1524a222a902be348ed445fe050ea9d88d7a90e3e361"
    sha256 cellar: :any_skip_relocation, big_sur:        "e83494a4a364f9558f0030e13e9735453dc87f1dce815b5699be85cb3a541287"
    sha256 cellar: :any_skip_relocation, catalina:       "ac497735b2a905cf27108b27dcd2a6ccb8d6bd75517806c83ccb4e986ad929b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a722fcd7e2efa98338ce2bc755e743a1e94737400b81a686a592f5c8218543"
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
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
