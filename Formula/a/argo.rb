class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.2",
      revision: "16a52d67daf2f4a8a76fa8bec02a76a46aa46257"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4b0920c7f52178e5db3b7d88c83e239669f08452342a0e2b9d707d6f19189e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbe5f7f936766272ed72d40a78fd86935a6d7808d5079ef950e82c74ac80062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1caca123ba7f6934be4b5c7f16d63ec9a081930006c92586d6cb05da23ae6dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c7033466ac3c7bc3875656a7a582e212d2b15daa7d4393461a24708cb252379"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59658873da18e8fb0bfb11d61962595e87f201112aa7e50a97a42c11c8dd624f"
    sha256 cellar: :any,                 x86_64_linux:  "a72b609d494f871f89da55449d05bbb834f602ac868083a8cf6dfe98c6044921"
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
