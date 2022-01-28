class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.7",
      revision: "bdc14b0d2e50b6d3b30f7b6ffbfd8ceae3214413"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb623b37fa946bb027baa8ae78d1de24f905f87ed30f8b0bcd5305f28a9f4630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cc402df1c5ca74ab4ec2ca30a5627063ec08632a43d9221ef5e705ac93845fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b75b9914656b20a278ba684659c4b51e021af65aba6be346d471f96fd6fec799"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccbd2a3aef1c29dfbb61201d4b9e695d5168cc483ce660f040747c7ba2694175"
    sha256 cellar: :any_skip_relocation, catalina:       "930ffb179d4d18e9cf613c7a075ad3ddfdc6ebd56c7ab33bf1291d87e1804ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c76f9715d93cd36237550190a16e6869f109a00198689589c2343d8c5f05eb"
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
