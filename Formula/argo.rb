class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.9",
      revision: "ce91d7b1d0115d5c73f6472dca03ddf5cc2c98f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2459d72f7d0ea5a6012037839819b1201699174bee3c47644b2249964f14f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3645647d142d356fe041dbef5090c2ee8c8c1b0a0d4d003275e2ec364fa2dfa3"
    sha256 cellar: :any_skip_relocation, monterey:       "357857b253c6767a3a56c33be278aa70e68332216ff206055cdcff8a4876ac5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3bf2ee36029a82cb9ce7bb870481870ef38255f3fe0713cf3114e5b6b3eb4e0"
    sha256 cellar: :any_skip_relocation, catalina:       "5f1abe6e272f6ccd79caf325be501353189e3c0146a7780bb1fef296b9296931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5207a92a3512a078f3fa3f52d0d59ffb5d140470501fc54efd112b375303cb89"
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
