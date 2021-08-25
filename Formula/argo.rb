class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.8",
      revision: "0df0f3a98fac4e2aa5bc02213fb0a2ccce9a682a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f8b04699e665a8252fd500761064b36bb1e2fbbf73160b388ba3256c029aed5"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9346a5334135ac40dafef1661ce1164b1f2dbf176c45c21241af79825c2c607"
    sha256 cellar: :any_skip_relocation, catalina:      "b67cda110eb285caa8c1474614234c80c55c6eb5c57c20da8000da099a36cb68"
    sha256 cellar: :any_skip_relocation, mojave:        "b02666cee25d2195ee17c17d20ea5e15d22eed985018569c3f584cc7e52390d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e68dcff03fee6597f6f1dec9c103f3cc90c404ed74667d05ff38021c24c69c4e"
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
