class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.11",
      revision: "ee939bbd2d8950a2fa1badd7cfad3b88c039da26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daeef9c482119a0fdc8e068bfee3155d49fa50e65befd79c795012ca24b70e30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf8b51cfdc0cbf9ff12df0362b622b0ee728f28dada95fb719b5c7b38a00f737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b47c6334643be52bc45a849885d3a7488c1af51e29541f39cb4828fc75e9ab2d"
    sha256 cellar: :any_skip_relocation, ventura:        "792c440293441f83564d60be7e53efb7389d1466132e5dc2e63501c31eebebec"
    sha256 cellar: :any_skip_relocation, monterey:       "42fd983fec9e2801866ede9a7254353c7b990000e31662e0ff9b4f6a06b097e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfd6b6dfb1ebfcca1e92cadde1b4a9c17f2b6e78decd78c836ed426b495ed271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f336d07d31ea0ccabedd5edd3c8304aeaeb9223121fa41fc602db9db2ddd19f"
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
