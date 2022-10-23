class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.2",
      revision: "c08563baf7bafafe3aeb3284cd3410308603cad4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb56dccfda38c846ca13d2498c7106a3fe8d3e12673a8bd2db514946ab878de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1f00cf19e6ab1e5e0ae377d105a062431ab541f880713c37ae0b5888f7a0922"
    sha256 cellar: :any_skip_relocation, monterey:       "46672c8c14a57fdbc261d471e9e5c45a149e895ad9d32a43743b34457e0af123"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c4e7ec3959c848df9f2c0a047bfae97588358869e1981b436cff01227567b1"
    sha256 cellar: :any_skip_relocation, catalina:       "35ad1b23ea0b722b2a66154c3c25de30f10ff180746afdb53d33d265bc058921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eda854f2058d29bc58f5d0c59dab495dc641c6d217eeb7a796118e2f8c2c11ce"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
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
