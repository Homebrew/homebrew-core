class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.5",
      revision: "1253f443baa8ad1610d2e62ec26ecdc85fe1b837"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f09de6959c52fbc9ecd60ab0af6608e3259299496cca19b4e9955ba6a92aab37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e495a7a825f4e7047a7a65f30b1c88d7a2899e73d8386a38ba56c7dc4039e87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b47474d98d86e09f531c942ca87cfc02fc772290de637b939ddf2d827b5c8f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a4373727e02f29e64084c60c2eaa076728d24be159c9cbdd906cade8acac06"
    sha256 cellar: :any_skip_relocation, monterey:       "114ac6a51e9e87a9cac92921a01563d52909eedae50b7c0d3618e2bedf2a428b"
    sha256 cellar: :any_skip_relocation, big_sur:        "730d0d9bd0a9cf4efd1952dd577ea6ee7903702edec98bee848a238e1428f548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114c3343e2667e3d102abb9222ef9e2b4882d9e80edb77f90880711d5c8fd9e4"
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
