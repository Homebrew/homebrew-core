class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.1.0",
      revision: "6adf4f294a824fa89513e2a33bbd957337770948"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666b2c0ba4eb110a4b31ab4c796ee1571650776576d6e8a7e5784542eab39ddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0989a6de3c1b3fae03ed84b5c8253f1d0eb6cf45b8fbe3ad17ebd49f48a1adc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3072f560fc5547f338cd71758f841ad7a315a9c135e0a07b6257a4ab9fac7d59"
    sha256 cellar: :any_skip_relocation, ventura:        "d728d0b02b59d255190e1bc3fcbaf796f3b13a63b629686e09327fd54fb2d637"
    sha256 cellar: :any_skip_relocation, monterey:       "a7185fdf6a56eda200f49bd31f421f228c5890c83bac02183563ba676ea0ffec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5e963966d10ccadb079645b3143bb3afa0e9fe2fb92c843e6fa74441fac0e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5d0fdf3d437f07d7d284229344354e6575fae809dbe9fa5857277eecaa7ed8"
  end

  depends_on "go" => :build

  def install
    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
