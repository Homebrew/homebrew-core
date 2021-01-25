class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.5",
      revision: "53f022c3f740b5a8636d74873462011702403e42"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "68f0849f326afc1d77beb82cdeca8ef9b553869a08aafc41413a6b56ab12e424" => :big_sur
    sha256 "ba77ab9b54808124026c52a68e2c396326e9ac57673a2892ed6c8993c3215c1c" => :catalina
    sha256 "1f100dcd78d31d2be44177a4ee31745bdbc74ead094653ae5afd64d34ca3e612" => :mojave
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
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
