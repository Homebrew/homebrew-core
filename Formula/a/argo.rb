class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.1",
      revision: "9e69e2164ea705f02b2a143de5700fcb5d7cd46d"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a67cb283e6449b85920995f0a4baa01fbabf05933ea0a7e55b29cc80fee6503a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d69a75e0202860fcc494346ff71c7961857adaab842494498fab623a6b4bd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79c2819de6f067fde7240961bc0e06bd9d20dd92bce7f6b65202e1af65fd1863"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9072783517374ae9bfa6e054d9a8ced67a71200efb603e096eea7d20c7c92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d71920f391617f30c760247fc571ec1eb46461992a802637a6cf91780a1a628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42173eecc5e063db39496883b381ec258934066f0ba1d2439963ddddd3c1e9b4"
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
