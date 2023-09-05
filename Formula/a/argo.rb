class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.10",
      revision: "bd6cd2555d1bb0e57a34ce74b0add36cb7fb6c76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10b31f4057ecd9a57531845bc6b94637b9ed44064023b4a84bdb666affcbd82e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafa0490fd66e2e322c66be2c3289c94b7d579a9177313497a649a47c5c96e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f73aa1a65fe7c6ea5c5490f92de598a87297174c2f73c11a76f860c735986d"
    sha256 cellar: :any_skip_relocation, ventura:        "12a9a8b7fd1ce9e2dea8d408ee78f91f31f6a001b80c463ed848bebb9dc739e8"
    sha256 cellar: :any_skip_relocation, monterey:       "5e6c47966ca2e38c023533e87c9acf3333d4fd6177a7812948902842cb6e9ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eb0c1fd0a88bcdb0033b225eb6a52d0fdb0cfdebab58cd4c632dc55cd32e5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df65acd2d9b563c10f1fb7aa48a2ea5e3d537d268fd9c58be03179a93a4488f1"
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
