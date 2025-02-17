class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "9943f47cb1c469316d28f11f845c44e63802e9cd37d28b6a20b1890f4c2133d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c851554d1663594aeedb701c14d4c21334585127d1395a02141ed112f9cb9f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c851554d1663594aeedb701c14d4c21334585127d1395a02141ed112f9cb9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c851554d1663594aeedb701c14d4c21334585127d1395a02141ed112f9cb9f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4199945f5682c4cc98067651b0a77f8ef649f0ca598d4e331c03e371a587f0"
    sha256 cellar: :any_skip_relocation, ventura:       "ba4199945f5682c4cc98067651b0a77f8ef649f0ca598d4e331c03e371a587f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5a67b172d1685c7eb4b4bd22c08445db9afe73a139c9827d3dcd1ce4ceda07"
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
