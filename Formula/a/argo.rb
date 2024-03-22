class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.5",
      revision: "c80b2e91ebd7e7f604e88442f45ec630380effa0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e2885517669e370542d09a37a93d9343dfc8c96bb7c706b7ed3e6db5f9fe9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80abcb471afd1853515e4287df7dc9ab22ea2e585aeb784317bbaaf811231092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b11dfcfe4f988074adc6971ec674f2e544fef4f90f68b7b30b4807d78a7b1934"
    sha256 cellar: :any_skip_relocation, sonoma:         "8762db0f04e302e572ac12d241a08440c330635a5c08141eb62a28082ce5ca9b"
    sha256 cellar: :any_skip_relocation, ventura:        "c284d96f50ebfed2426e3976aeabe1d967b0460c08317c16b9de30b07211a5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6f85e624931096b91ac677dc61f09eec452558ed8bf80c90626bebc8e33d44eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00350ae5ae21230a38fc7626f6ff90c487f656b96ad63c363ed20c9114b2d9ea"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
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
