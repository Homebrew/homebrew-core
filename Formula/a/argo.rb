class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.4",
      revision: "b5b4d665e9be9b87c115f943584c3e0ae96fe073"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05e601b8cd3b57a43b68a0a1b45a794c99924c58cf2569be3641d43527dc7ffb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc04688f5895b1aad0cf12dfa9ec9426bbc9f7f70606661032bf6668eaa70e07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c5aa527c6db73e0cb948a509195f864ceb7fbf38ba1ab3405b2f1d5608bf1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63f0e4f565c1e8f33e441262695424112efbfaf8693b356aa942196f6575ed39"
    sha256 cellar: :any,                 x86_64_linux:      "c267ceb262abc613aea5b41930b47b068481989a4e86ed30257549de13d59549"
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
