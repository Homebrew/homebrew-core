class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.7",
      revision: "8d7dae690e152d19fb40f7affbb68fb783b32172"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0badfaa2569725227a209bd8d816ecaac709964b1cee11ad6a8bc5b35b4645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db320d07bcae2511f368d9e414a4913d546b5f148db218fb2c6c0c0e631153de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbe8b52bf7397c4126cbcf1336fd2c5f7dc709dd7dae09ae2b64b96c34111899"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7e0991e5c6bb4ef7ae9a9702f998efcb1b530c6378862bc42f7edd5ad5bf63f"
    sha256 cellar: :any_skip_relocation, ventura:       "844517c65d733d6ddaba2e41705137e20cf3be6f382d473f98efb9a3d7faedad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31355ca96b8e750bf985c6c265ccaed458399ba22ac67b2c1f140e729aaf4838"
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
