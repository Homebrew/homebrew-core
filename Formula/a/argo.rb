class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.1",
      revision: "877c5523066e17687856fe3484c9b2d398e986f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bba7a31c222832bea5ea061aad2788d36ecae3a04bfff9ec370605a8f0a95b61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb257466a976bad7d56b9e0477a8bd0bd5deb10b0fc7c185a177e49ade430518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ffebad75fec91ab44d8743faab6f6a546ce81891ca629667ca0df30db5a160"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd223643aed66359799d70966576f434cc082519458ed589e281857df26a58af"
    sha256 cellar: :any_skip_relocation, ventura:        "138160bc151edd96cb26e184ff9f26934eee259c5f3e88ab42170209a1965ca3"
    sha256 cellar: :any_skip_relocation, monterey:       "efca0244f3e67e007be3e1e739a3c0b7b034a6d0a2637b15d064867ecd9a9a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b442e907532f2077fa87e6270b6ed0f64100745032fbb9e4958c36f4661412"
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
