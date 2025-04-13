class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "d498284ee6a523fd4b87d284693b313fea289b4a374f2c0d1b5023f2b18bf77a"
  license "Apache-2.0"
  head "https://github.com/viaduct-ai/kustomize-sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa747b7c1f4bcfabfd3942ff92a66ee859762d82a495509742df676e0682a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa747b7c1f4bcfabfd3942ff92a66ee859762d82a495509742df676e0682a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aa747b7c1f4bcfabfd3942ff92a66ee859762d82a495509742df676e0682a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9665ddf3104edd404a8a6b8bdf7e4aa823327c976584a0ea0fe7ed9f8b33456"
    sha256 cellar: :any_skip_relocation, ventura:       "c9665ddf3104edd404a8a6b8bdf7e4aa823327c976584a0ea0fe7ed9f8b33456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ac64e22aa36b5d1664fbf1748a08b76d3f984f00277c1ac329757cffaa475a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~YAML
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    YAML

    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end
