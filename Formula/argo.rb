class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.1",
      revision: "3d606939dcc78d22ff5fa1401703c619639d019f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49fa62c3cd629e66ce4f2178fdac085e320a3bd00be8f17c829b0090fcf67690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e829e3ca3d29df1d0508ae8d6fc128f1f848274f50489def2e5c503424f4d559"
    sha256 cellar: :any_skip_relocation, monterey:       "09ffc099faaec34b08205cc67d952f26949a2717c1d562bc6a6572f563fb7f48"
    sha256 cellar: :any_skip_relocation, big_sur:        "4577bb26180711b44ae9b9400015d5b81fbf9430ca1fffc36191a6df9c6f2f6c"
    sha256 cellar: :any_skip_relocation, catalina:       "79b90dd5722c1089e07fecf34270949b647a9fd066c4713b7d938b6675cc7877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d070beb612b8a848e070af0b5b1808391d72ca0055d4a2733984faa565c0d01"
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
