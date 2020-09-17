class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.0",
      revision: "f8e750de5ebab6f3c494c972889b31ef24c73c9b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2030c707b7f72acfcc77032eb48ffdea1d2674581765f7ef74ddaa92dada2ac" => :catalina
    sha256 "1d3bca298313fcd71fd69ea8369e702ef36f2f9d8ca76beb8e7656c16ab1f409" => :mojave
    sha256 "f26bc30ba506e308830542ca69d0d535dbe0c61720be18c0d077a1803c49c780" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
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
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
