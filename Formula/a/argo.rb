class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.5",
      revision: "6c80c7e56ae601bce4a9f042767aa00259eb1f41"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0c35f06af5d4a2ea53403af42cac9044e2e720fc404017826fdd00c6bbfede2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "719ecd36d98ce830fee7037f3fa3650b862a788c641af0a9cf66e0a8d8d7d67b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44af019270f6abc8f637e243e7b839f5740a00fd646e24d4f0d0131a9f4b682a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99ca48be107cc4f894cbb11057a371747989c759a1772ee4f51857384ed6b52d"
    sha256 cellar: :any,                 x86_64_linux:      "ce37920ed6622ad5923e0d891118e031082acc64a7d60e417a701f9665397161"
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
