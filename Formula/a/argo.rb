class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.6",
      revision: "43021573c5a35cbafae009043c132dfcef43a112"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1069f593b933251842f0a5ef3e51c67c76d25d34664aacf2865b5fa66723fad6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9419d62a5004d5f203770cf6c6e5165ecd0f02dbcf0c7b8ca6c46fa44f557729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6554500170f486fcfc8cca4e95f504c5561407134c2e795a978db54aadf3790b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c8224f09d46a966cbe9aba41f946aae20db1fbf694d542e5fb30b364b280163"
    sha256 cellar: :any,                 x86_64_linux:      "bb765a4956029d28eac48af270345808b629480eabd6dec9f3b6c0e4cd1729eb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo", "-j1"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
