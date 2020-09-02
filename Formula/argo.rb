class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.10.1",
      revision: "854444e47ac00d146cb83d174049bfbb2066bfb2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ada69adf52ea338e2b3a9779c96f8ea423104168195ecb8752259833a693c586" => :catalina
    sha256 "11bf0f68a12e9277738a9cd4bb795ad0ab835a04e942121c06e62a30c9287f7d" => :mojave
    sha256 "bcaa4a9bd5f2a3c1f83cdb659440db88a15c2847d156aebd3c39713fe361ab9d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"
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
