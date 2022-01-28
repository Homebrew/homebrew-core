class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.7",
      revision: "bdc14b0d2e50b6d3b30f7b6ffbfd8ceae3214413"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e3828a7191c2e40632c1b8c2e390d5daf0ff44c7c763ffdc850258ee68c06e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e1f89aa4aab88341c743a677c8cb4689e40e76c316728bc1913db6028fb18a5"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9f2d10193703e553ab1a18c4ea635e34968f95b6711a6440b45ee25292bf43"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9ddc98f958b3f10fbc816cc2a58c124b81a44bfbe3fd3418d92200ae77fcce6"
    sha256 cellar: :any_skip_relocation, catalina:       "e957e7d0e7dee847fb9f3d61ecd0e44dd4308d4bed4162ebbbd254d6657bbfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb460cd5e618f53d339ec0c624cd18089a19149287407515dddd638d8c45e27"
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
