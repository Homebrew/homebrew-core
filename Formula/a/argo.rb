class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.4",
      revision: "fe0af119897a54f4c7db117a5912a5559c46532f"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dfe0d05715ec95d16b449b30eb730bbe64b22f6f0274655ec528d39ec3f0cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9922ebf3bc29d7c892b1dfd03c7e1048c321153c4150732bdd3b9c80051fb494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fa2f1271e7eadf8bdc82b44384cbd218845ef02e1d16459bca9ff56005e333"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c89b2b35ad9b36fcc7dee4d61b716b589c8a92018fb6b582da1299b57e0357b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebfb30657bb098dfcab9ce77af9c523ec33393f70e6eca29c8d758451a0c5c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd98cf046bd7aeadf904f299b998f25e9a5eda60bb7ab04475dd40bf2d9f006"
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
