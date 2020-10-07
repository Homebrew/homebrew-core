class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.3",
      revision: "a00a8f141c221f50e397aea8f86a54171441e395"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9e94bc94fd6644981eef1624b367ef8a4c2c5739b7cf2e5fd346a9949963ca" => :catalina
    sha256 "5adcab1e588d351488fa28a34aa737e6a78e502a01f0e9d24f58f90823114763" => :mojave
    sha256 "d33e63d89234fbaed5f0940d9e230b094e74869a7478253282d120241e4de8c2" => :high_sierra
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
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
