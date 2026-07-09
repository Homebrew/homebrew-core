class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.7",
      revision: "9aeb47ce10339f4a14819335c6a00027353ba0df"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f17f247de9f0a1b2f4e5f67c2232d6eace6ca48d11bcdef356652963eeb5895f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9150081977b89fdc785752c7b2d7eecf08f2b99a67f8f819b021a3ec3fdd1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f447ec26e6d9fa36cfed6c3ae27cb41228458e2918045131885e493db44d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58bde3ad029f8d45b4dff07ecd35cdf28c2a80781cc7b3704e4665b6774548a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ce7a537791714dbb71d73c91311fb454a688f507a6ac5bb48b81179efde848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cd1cb1afc986e770f6a1f5d3d1898976575229511910db421bf471c93eeae4"
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
