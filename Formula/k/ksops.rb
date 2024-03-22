class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "e7248a158d503a73d9f658cc9ac0ccf16a3d8efb856d93ca50a97f7b89332516"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01b925654d8b6e452ddf7903b6cd5b6ac9fd8347b68d1bc948274946f4d4d245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501ea68e549ad1c75d99dd5c5bcf75a4309a4cfe0cacf9dd5e9eeb67d58b89c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a445c04e2976c95d9d65d068a1980b1a32e5bd19fc1bb5cab3ba6025ddaa23"
    sha256 cellar: :any_skip_relocation, sonoma:         "1098568c24f1a9372956a84c9a87ff4c0d8525df62222d01cad6333fce3d5355"
    sha256 cellar: :any_skip_relocation, ventura:        "81ed729afbf148d8633139e30f48eba33e187970582995987823daee3279168c"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd4072fd87f791b05f03bbd180c08f4752f62f9bb5c9c13faeed48ed092b919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1439a2fbe18e94005813c4a238f2c28d40a28f31c3086a66328e9a69226cba14"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~EOS
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    EOS
    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end
