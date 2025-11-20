class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.4",
      revision: "9b9649b0af3d5006f3b6688cb2881db4fb324a96"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f12401aeacb27059a1dce38d37d601ff57acb32277adf43881cbe28f8945433f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e331994b0f19f1e06881fbd26de0d83712bf554e3f10d7a91b637e7285c216fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b671427ae15a236716b04e296eec7c36f344cbe20e446802deb7cd67ed2a4344"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e6f8ec14f26a88b39a553a0fe70e00cdd636ab15033c0ce66885dfe582a8d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ac55e304bd1c4f4626ce82653a4cded1903d56e1916790ec780894e773792ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a94752f637400c1683d5bccd5a03356e2cb28272e77f8563ca5be5b75324d74"
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
