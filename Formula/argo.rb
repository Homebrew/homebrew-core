class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.6",
      revision: "5eebce9af4409da9de536f189877542dd88692e0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "241e5f0f0fcec04d4165010ae300ab0f8d96f74b0005e288ebfb52145e89e86a" => :catalina
    sha256 "7d1f8de5916c1b2692aea4ca4559d0704fd17223f3969bd75b07611353f44c33" => :mojave
    sha256 "8dfa33c0138e17fdcfca45b5ebc11555c378d81d3aa14e638a435d17ef42485e" => :high_sierra
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
