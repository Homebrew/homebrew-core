class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.2",
      revision: "8897fff15776f31fbd7f65bbee4f93b2101110f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b60eabb2513c4f6e309b6d5d6b6ec6cfc6855b94f352945d6dde76f424a63d7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682e6bcfd6f0f1adacdbcc1f0bcd87140799858ddf37e77afa4d3fc91d568e14"
    sha256 cellar: :any_skip_relocation, monterey:       "38274897bf206c54b18c5a591d4a099f9a5d08050f89745671511d3ffb03929e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cad46141fec15b193408331289e8e4009fd3c4d51ff68de71377290ea0b23610"
    sha256 cellar: :any_skip_relocation, catalina:       "4188e9574d1f77cd09545f567a83f5698543c503e40fa407d525208bae173dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daae7056f28b2cbea40c5ef3bf201f52f0dff0fa4c6ed7d941382b8e3f86fdf0"
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
