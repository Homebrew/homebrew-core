class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.12",
      revision: "e62b9a8dc8924e545d57d1f90f901fbb0b694e09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9181bcef3f2a89b1756d6291c865710c279ffd2c485e1a64f2446598cb3dde2"
    sha256 cellar: :any_skip_relocation, big_sur:       "189bc8918cf02d1ede066b000218aa9118465ec67f9fa086d2daf1964d23b1a4"
    sha256 cellar: :any_skip_relocation, catalina:      "c327c2ce54164dec6e7502507d342bc8450610af933f4cf1c236ca17c73ce7d4"
    sha256 cellar: :any_skip_relocation, mojave:        "2961e07796f1aaab2dbde277bf1420617cf3ad03c5455454e4beaf7f28fb9dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141429b22e2009535febd22b18f36dbeecf6b1133a21c67f89cdf5e1a26878a1"
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
