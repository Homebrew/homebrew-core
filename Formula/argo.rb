class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.4",
      revision: "571bff1fe4ad7e6610ad04d9a048091b1e453c5a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bd8f9e24abc2b4d7dc38b30cbf1b6058e51c8b34f536e537ee7752ba749745f" => :catalina
    sha256 "cfbb7158a4cdb6849633d8491401b0536c8ac788b3c1bc071ccd22112ac1d064" => :mojave
    sha256 "b979d028058c6f1204ddfc33dbb894779ad3662fd8ef255c06f3a1019ad733c6" => :high_sierra
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
