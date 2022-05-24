class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.5",
      revision: "eefc60b155c4011a3706d2e3cba90f099ee93b39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1d0dacadff891720125c1a522e9e8e644d292c043ccc8c7e3fbda684c465a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f018ad1319ae7cd56c9185e1736aa3e8c1ff179c49c21e38349bafebf0765675"
    sha256 cellar: :any_skip_relocation, monterey:       "cafeb003f01c7a62d93728fe417b9343c7c7c1fdd647bb1256a5bca583ea0006"
    sha256 cellar: :any_skip_relocation, big_sur:        "41703d06c7216192c136762bfb45437c0202dbb0e5932003299500d4b18b5463"
    sha256 cellar: :any_skip_relocation, catalina:       "4dbcbba1277a0026d3072328d136a2a87a91ec7e2f4e811c3ba0234bcab2dd4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3d2a36d6e97ac81d3a246b8765593b3e53e4b9b77908a9970433caca5742cd"
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
