class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.8",
      revision: "23eda86c404b1f11cde47083ed7a7a6eb3e9bdf9"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da4a26a6486416f7a2fe55df225681de31709f28355fd8fac7cada06a165a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603993c968005c06d0f549bfb4cca81e4a57589b0c51ed3b00066509d9f127c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93de893620518fe5397bd5bc10beb7a0024bd46836881b6da70c83ff615db0fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "be6a4c8710c535c8c7e83d7aaf0daa94109cb981c6365cf5511c6c1dce5a5fd4"
    sha256 cellar: :any_skip_relocation, ventura:       "94a707cd34d957876513f30996a2606d7fd781a2948b986f62899b36d02da2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a304887349678148623aac1cc24e86c54a381032b2bda7f1715bb816da4cbf5e"
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
