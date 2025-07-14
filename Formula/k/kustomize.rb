class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.7.0.tar.gz"
  sha256 "ef3b7fdf5c8ccfb7d06ad677e116cb9f6fbd11ee170412bf206e30d8f190aac4"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a9af984fe362da7d97df2b7dbb0b151bf60b9831f76b08c500f4b0690fe08d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c1ce872731d1ac6865b7eff89b328690f3c4a26250c1e7071b4e2067d1f30ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c10d2c85410667ba82cf89b39e288c793e91a42d887a8a63d70b5cf7a59a9505"
    sha256 cellar: :any_skip_relocation, sonoma:        "09920bfd22a4238fd16aa575f1cca25d7122287054a2d73201d3ba7bc4aa6630"
    sha256 cellar: :any_skip_relocation, ventura:       "69b75b8dd3335b7e1c42581f1f7334db23c950b763fa178f8b6bf7f19fc69cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcdeb5ba58229da8b6dff3b2be7a12ad924d61c6c5ec21e3c492be7d7869c3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a61bea6f91055125183ab7f2ee5edc9f305c6028561007f3ebfac4be97c742a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
      -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./kustomize"

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~YAML
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    YAML
    (testpath/"patch.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    YAML
    (testpath/"service.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
