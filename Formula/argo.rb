class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.9",
      revision: "5db53aa0ca54e51ca69053e1d3272e37064559d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1fd41b80b2f5678ea88b0fd9eae85afbcbd33bc2a14c983905a20ccccd1c6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12b0a4d04fc272392829366c656f003cb205cf2e3b28e269fbc0f57357256238"
    sha256 cellar: :any_skip_relocation, monterey:       "fa69549b8cde42b940ee34684fe20f487da2c226e24adc0a2c93603c0bf0ab41"
    sha256 cellar: :any_skip_relocation, big_sur:        "84898076f59f4f2c70bc3b1f1463b028e4aeaa048aaae55189178d69aac47827"
    sha256 cellar: :any_skip_relocation, catalina:       "482fb2105e02746d1866b5d5d1d5cfaddd818f35bfcb95c47a6935df17875c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d689bb3233217e29718c2cc6040793e3fa89d9c94c346467f337c5122db97c4f"
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
