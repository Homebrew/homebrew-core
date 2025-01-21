class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.2",
      revision: "741ab0ef7b6432925e49882cb4294adccf5912ec"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc785afda51481f2174d7ae417d0f42ab9dc0e61b2cd5a660e785f7e5bf3c4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0a3c670c3e3248b8717561d81160dae8aa9c3ea9c321965092c9deee1ced37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ea83eff3f3a6f9234450a12c7c2ec0ab8357e96c0844c528dad98465ae946c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6838e9684cf6fcc43a01260ef3a1c1c89b67fec2c3032311a4db546a9aa1445"
    sha256 cellar: :any_skip_relocation, ventura:       "1af8257d727cac30fca26fff098c296ef5d4deb406541f6aa826dad6883ed882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99221df86b8a57717a0e0eb49a9758f264e7229796cc3f531ac9036c870fc20"
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
