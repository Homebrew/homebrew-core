class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.8.3.tar.gz"
  sha256 "c823ae7b7e1461d82dfe7e592823796c6a98d9633cdbe33c64508b65c9911a57"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e96fd546500f78195434828a7736984fe29ec4078693567d0902ccc504b391ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee947456549691e4612d646628c1f8210462b0c5abc9059c507703cdb4c644f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12046a80d3bb5e552e033d1467910f7262b1b7178fd78f63d4e6ca1e9016ebfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bef7ce77cb76a6a5e0dc9ef50e4c270cfce3cfd7b1329d5618f9634136be5412"
    sha256 cellar: :any,                 x86_64_linux:      "ace2f619f01d53eefdfc2cbfdecb96d155e5bc67748162639bd15344a6a28815"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
