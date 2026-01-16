class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.7",
      revision: "26c24fd5909b1eca470cfaad76d48cb24af27433"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "678206da1ec63cc7b4ffabedbbd197851a3c98d4a06d59f7936c14ee6de8da47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac362fdfe94aa3d38a7983979ef6510671d1a7f575ec66413ad651920a93e528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a73a4a01777318fd3aa7771452d66a0d2e464ca5ee87aec108f35f2e3894271f"
    sha256 cellar: :any_skip_relocation, sonoma:        "286407ea1e702529c9bb4a6bf0fb3abc2e879424089946e376b4e142d5efe131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "514f2a5741555488bca69003369cc0a3b5e074989ed4962532751aa6b95a6812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d5c998afde1e1a43c98c91120ccd0cb27be01f4ea7ccbd2deea82ae92bbfd5"
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
