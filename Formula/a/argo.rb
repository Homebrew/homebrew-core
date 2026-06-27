class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.6",
      revision: "277e9cef0ad16d7eaaab253573d0695951a65dbd"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94592b6c3e102b6162097c5c51f0b875cc25b5070ef1932917c6ada7296e9e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705430f4a1dd3d741220a9f18f80ffddc5989700ec98ef7183d383ca23b73764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f15fd1a029d8ad154e24767dcd4aa16ff54f3ad8b10e8e15612e919aba6a2d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a3cffc8a0882ca3276bcc5bdaa59712db27170be1a5ccba3d26a4b41073a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed5249756d0db3bc93f1a53b9e1b523645a490639e0e304fc7eeb6d4bedfc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5309342220ccac9a2d948c02658f100d04adc0ae501cf1ecfba5798825679fe7"
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
