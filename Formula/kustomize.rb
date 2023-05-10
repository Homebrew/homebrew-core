class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.0.3",
      revision: "3cac8448d3d604e1a38cd3c4bfe4585438f259ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbdc6f593427a2b984ded62f9630f855b89a4b51f4a2073d2cb2472b1fe9508e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217428144a80fa0652cdffccbb9266d3b66235eb257f30a4f9b29cf1eb5be86f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e9a4a79cca8adcf808ff0ef95241579c62c555dede7b99bf0fab70f0f2cb70"
    sha256 cellar: :any_skip_relocation, ventura:        "48c358a5f3ae14b8cc7c5ca80a8bf938a0ea0b10ae93195d16e9310612631dc8"
    sha256 cellar: :any_skip_relocation, monterey:       "29ae021238eda779a93961de6670429cfcde48d552885ac04790ee3943ad4a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "8675f5f042106823cfc886136130d1969bd78c6b5c0007aba87b09e7c886442f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64fafd82844704588435ef680441bc24d32e2f69c81fc981b07d91cba11e6903"
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
