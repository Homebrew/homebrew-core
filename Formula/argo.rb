class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.9",
      revision: "ce91d7b1d0115d5c73f6472dca03ddf5cc2c98f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1235da0e2012ddb532e3537e49e237be6bb37f76363567714a05653479c1bcd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3190fc852ab0449c548f2622a261b35fbff8e1c91f4f6ed33a29ae80c6357b56"
    sha256 cellar: :any_skip_relocation, monterey:       "340f43568cb0e83b9a3722d37ccca79362259260147572886b74605098d84235"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c79f658ab484140f2394ef55b07fafa69443ba03331c83e71599d2525b3b08d"
    sha256 cellar: :any_skip_relocation, catalina:       "82f94862996ae11ec5ac4415158ff4cbd1ddb321fe99428e4b0dd96e29955f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355dd17e61f69dc77bdbd6768b413d1920dd0290b7ffbe9778fe879eabc246dc"
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
