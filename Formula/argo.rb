class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v3.1.0",
      revision: "caeb46d443b6491fdd9716c6815ab29525eac632"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec791104d2acd5f407d8576c0db9dc6080f8d2a7875a854ec70767b171fcd405"
    sha256 cellar: :any_skip_relocation, big_sur:       "81cd52227351e9c14d9e3d41fa054d7e03d0c449351618db4388c014d30cfc8c"
    sha256 cellar: :any_skip_relocation, catalina:      "7ec5d3ace1aee39cb422d80e6945ee5ba16efc7c601ef8cb7db3fa5714c720a0"
    sha256 cellar: :any_skip_relocation, mojave:        "66a1e8af30a2f09ae64e87593abe49f927256cf89653b1806655681411cceea5"
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
