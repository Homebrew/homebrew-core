class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "a843b5bbb036027c72bc37fce29135362b8a13e58e6d53a760ed0b7dbe8fe66b"
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

  # update go.mod, upstream pr ref, https://github.com/viaduct-ai/kustomize-sops/pull/269
  patch do
    url "https://github.com/viaduct-ai/kustomize-sops/commit/feb0eae92c10c1e248928be55f6577f28b6468a8.patch?full_index=1"
    sha256 "a9dbae051b35f209bb64bf783f3d2c36f6b26cd395abe3d92dbbd996793a965d"
  end

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
