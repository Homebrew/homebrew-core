class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.2",
      revision: "98721a96eef8e4fe9a237b2105ba299a65eaea9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "464ccd772dcdaf7b49e4eb46290c1e2519cc2410cf7e5d841160d8e2bdf5c7f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e5cf4487a7e0c7edae2de873ceb81f04e5b87ca1f1db3306e808dcc80c606c8"
    sha256 cellar: :any_skip_relocation, catalina:      "22b8ddc317cc13ef67b2b0d7974146b5cf08d4df14bd11348dc66359a8cfe6a8"
    sha256 cellar: :any_skip_relocation, mojave:        "5bbaae70e3c8e635ceb0bc3c6059e641338a40d03e6b8b9077625a0350309f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49920009c3a06687c545354ab9d627785379ab7b4f095a4ec71cda5ab199aef"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    output = Utils.safe_popen_read("#{bin}/argo", "completion", "bash")
    (bash_completion/"argo").write output
    output = Utils.safe_popen_read("#{bin}/argo", "completion", "zsh")
    (zsh_completion/"_argo").write output
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
