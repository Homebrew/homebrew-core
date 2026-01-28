class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.9",
      revision: "156b4f817914bbb2e1e3b93b499d1d50331e6af6"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9bc3b70de852bc164f41d9a44d008a7b11cd7bb1450adfbd04446fd89e5ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e171c2d6e846b5dad67542defa900aefe437ae6c2a4b1a5926394f45e2f0da80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4fa87f935665e6666667be72bee7701f72942e769a69a646899c46557bd1de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6eac7a6afce1e73e4cdcd6f1f8f937838058f4fd5cd6e5b04d78e393f99c792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad35824c82bb74cd61ce368f57b1cfcfdaf215b8f5431ad4094ffbea3a11027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a312858dd4688b1c83711458eba251939c504c11734132dcd2b6a7ee6bcaa9"
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
