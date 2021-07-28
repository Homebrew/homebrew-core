class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.3",
      revision: "9337abb002d3c505ca45c5fd2e25447acd80a108"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dd6da7c4d597261748078f8514be792e68bf91f91558b05ef1b6ff2a2b1f095"
    sha256 cellar: :any_skip_relocation, big_sur:       "e89b05c98b2010d812a1ab1f2e0171f144633e1d37743760633c5131d53b6586"
    sha256 cellar: :any_skip_relocation, catalina:      "1d46f8891bf970d3ac8bc436774dcc8f76dd8f0b26eda815a02a3c78e13f59df"
    sha256 cellar: :any_skip_relocation, mojave:        "00b19edda2363488d110bff446629eb7fdd70e83a216c844225ea36afc56994d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be5709ac3fda57c5df6e4f68e62bcf320e76e363362467c8ddf6aa1e4939ecfb"
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
