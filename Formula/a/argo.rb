class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.6.10",
      revision: "459c19db6e9dd86dd757c21644404cb784863fae"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd30def1326cc0cd4db4f091baabe9a7ce5e49ebcfaac548f562d67d15a762d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798a9d8d8a71426e607b02adb2982a6334e0a4ba99077287741cd78dc618349c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb79f0c0c80d5532063bcca3548de17d8658a9b273c5a64c2c61a10679aa2c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b9d0b2c25c4a6356c3191371f446f56093acd553754341985de299f44b77fc5"
    sha256 cellar: :any_skip_relocation, ventura:       "c5ecc8805500e7e5fc5f96e96d0a7bf57ec42a0fdc6f6aa60cf2f61d6eeacdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a556aff0b33ff4459ef08ac878124f6ab8ac45db6cfe2dc51368272911c51fc"
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
