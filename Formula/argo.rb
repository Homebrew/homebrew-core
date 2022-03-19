class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.1",
      revision: "3d606939dcc78d22ff5fa1401703c619639d019f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f302608523ed9ff00ae53a6b983baafac7c7503048c55581ae12b212d767c3b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c82e2b92a314af35ddd47b6d04f3b47a34b689e86ff63c1ed2c17feab13ed53"
    sha256 cellar: :any_skip_relocation, monterey:       "60f8b47100ef88e8b0c7d029cd8e7eb95bf55d5e581209d3f444a09aaa453f5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e652a2eb166b13f200f20c1010b42958a7a588924ed74dd87805e8d735dbdc4"
    sha256 cellar: :any_skip_relocation, catalina:       "15482f481c60db8c77a6285f50814f6ecb52d7ec08e5179ec9ad94f0ad1bdf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58db2bf1b2262ff0712c5ae8fc963e47058b7c6131040f6944918e8d911607a5"
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
