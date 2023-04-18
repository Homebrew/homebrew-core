class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.7",
      revision: "f2292647c5a6be2f888447a1fef71445cc05b8fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3a57a4e208ebbc0f77d62d549985916beea38002cee5100563d7e5c547d1e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16c3baa6a1a5305a40770f6409e16a5e9c2c6e73c3253ce8c0502c1248459b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4d3a92da4962e90388ae177ba33c153fb08dbb5dea12da6049ce01bdb0d5194"
    sha256 cellar: :any_skip_relocation, ventura:        "251bec21545b0e8ca255a095021f9c4ccb0087a91f93cb2e13e71e12ac1b7ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "869f8614b7029bc3524f6762eb4ab32fa6b45c7b7beeb2cc5bf2fe808718d77e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c4ace803b1e7e22225a7d1475fbb248360dda40e3eb1d1c2efe341a7e40d704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1974c38db749f9341c66515bd9bee2eb9c7ae828622549a466b861dea99de73a"
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
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
