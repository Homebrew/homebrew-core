class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.8.1.tar.gz"
  sha256 "4ea5a974c46ad6efcde4fd9c339ab1bd278a80b6872dda2d1a366936e4638475"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ccbddce9b9a74b5117932a76fe8a196c58d81deadfa90e160c1e8fcbc076d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4ad95901cff98eddc678ac7b33dd4067de2f4f7a10903b73dd646afd3d4935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a293154bd4ec5cc58c684ac0e3eda80e6b7d17d1a29476099d1fa76310fea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f0e0ebfaa6965bedfbc6d7cc46165f045ce5ccec5c420b70091766aee4bf4fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e8e30f0150ab2641f5ff89d4cf42222b234887fb684bb998273034145c8bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e8592d6db38d12c0b2af3daccfb446ecec021b98e7cc99728988bc4d904beb"
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
