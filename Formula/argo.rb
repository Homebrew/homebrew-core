class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.5",
      revision: "1253f443baa8ad1610d2e62ec26ecdc85fe1b837"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf9adebd0558f2d37eb8095ec03998ff013189071d715093d07fd74c663b2f01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5d21a61e15411fb85d8205ed2a98bc251beaf43bb0e4f3bbef61bf0ad0d1566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4826377d1e3545ec50c7762fe28f942364b503b4ac7747bc0ec04e17425f138"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad58fc83a28146241e689fa97c3904407e4c36dccb4fb65617100667ea4dd4f"
    sha256 cellar: :any_skip_relocation, monterey:       "a6835637602c3729b401ae676f4f336bc61a9eaef0bba96ab169df950dfb3d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8b73a2bb5766b99ff2979035a86683f70398f25dc2d2655a04f230ad6eeb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008c19f86145c749d533613b32514798bfe3187298f1f0d80f9b860f320938e7"
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
