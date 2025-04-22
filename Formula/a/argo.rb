class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.5",
      revision: "9e532061c064d1205610b1932a0fb3c4dc053421"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ab4990bd29cf65b0d566f3920f38933759a04ea8007b0940c3bc53ca6ee819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e65d5c473ae97db7660827f4548a8383cf7ffbefd9368657978905c377fc39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cec77f0c320d3fd2a31c070c51b919143ad3f3b54819745cb93514eb6b434b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d64de73eeb5345da6549566eba07d4851c581e2e1f1eabdcebeeeb191b4d88a"
    sha256 cellar: :any_skip_relocation, ventura:       "6f65fd8c6ea1b4a962c8c72211c1b4376e2fde5bdbd4da435996b1fdd40daeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620ea2bb09938a7a1b64bfa37ff34ba3847a41c1eee34e2f5820fe0914b2dfc8"
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
