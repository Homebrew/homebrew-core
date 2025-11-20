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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e70d396b3da0da6bb38f3c31edbadb41c2a2ecc2a9c724619fadb7e0207dfe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1daaf54c5182da2835585a74b33c8a3de20eff9076411d3eceeba565cabe566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dce029f0b716b861da807249960fb3d89f7c637ec800bd2a68273b986d115b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f0159756c7f81a667caab38f156e463771c3591e3a66ff87121eb43eca0719a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01cb1a1a0a390f606f5b31c9e094629af0dbdf0e86f542cc7ab44e4f039a3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24fdd60b8b7034438d4d3e4bb15a95175a85e55d8451c770b4640b05f4e6f13"
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
