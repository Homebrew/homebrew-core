class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.8",
      revision: "add2c5456be4d0858639067d28b38d9199e3ae63"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "646e1d6c23e682ebe3bff01942edaa3eea56c6358e9d4b3d915b318e49e57dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8870aad75cf5bedb4f3dc3449573e3213c9a00e75ba517e8d3c5398de2453ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a023e950fa26bc0734da5be5af8e8243860117289e5dec7f079d6763de13aec"
    sha256 cellar: :any_skip_relocation, sonoma:        "2675cab9e6fa6a0df381bc7e894b4e708257ed225ad6afda468af8705c32acc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fb2dd903fadb4eb310570089f8443983d7192721f43c5a410cc4cf0bdd2676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a980cde0511df4cf95ae33de85c27cbe7fec90787c29e54689f9d9ae2d9ee66"
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
