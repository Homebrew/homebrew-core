class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.8.0.tar.gz"
  sha256 "b1f441637b3e02ef2a20e6036ca44c14e4c4f0a59805685ae603f87225944ecb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6a7f68d08f572fcfbaf12159aa817ad023e3a939ceae9f29b8ddcf5084d1089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32be3571b5861e577ba2f40f7207279cddf76597c5f35bd99461c7314f72e6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd3ac541719f316f264b0e7ffc27d5973414c3a2f2cd31cb7acf4a8b35171706"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bba5cf3fce8ef568aa6ee2e47bee161c15777b21c1461ab6fdd1a90729f974e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe423c984e1e1013364b73b2b26b1541d419ad136d0e0e9e5377189cbc6560a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7274d6c446d49b864eb220923ad0364ab5119da390b7b130f18c8abc1b22268"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
      -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./kustomize"

    generate_completions_from_executable(bin/"kustomize", shell_parameter_format: :cobra)
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
