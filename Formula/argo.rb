class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.3",
      revision: "e5dc961b7846efe0fe36ab3a0964180eaedd2672"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d05705dce96d63b4e553489e02d4fcfc249eeaea9d8ce2a0ecbe72f4163413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b25e97c0dc63efece8ef354658950532e0f66c393c31cd6f2f07a39f6d4df27"
    sha256 cellar: :any_skip_relocation, monterey:       "9586068e9bed2953ba2235ad973d3b7cf1b30c6e80d4c6edc2bb8e463d787d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "a78006f22ba54c2c84776eea99c70f28acb864501fd5555d5110ed99681d538e"
    sha256 cellar: :any_skip_relocation, catalina:       "186108048fa6e7418d6fcb9db2c249a78820c1101190024c06179b8563a820ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a371bef9c59bae21c641c4aee5b6f9d8ad6ba2bbac493760cb507401b858f234"
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
