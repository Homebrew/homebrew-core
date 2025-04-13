class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.6.0.tar.gz"
  sha256 "80822d3227c0dbbd38bff19c4630f4fa7eccbacd0ff269a1795a63aa3a45714f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6b8ee41eaa7b659064ed70af60dd3c79b4064465f66074cf9d5dfc5301dcaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e8887e642d4af6754b15728feaebd0e326d45547ebd1a6a53ae299d88cce48a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec32849849c7f51ee4606b6beaad41c83a0e49cdf2b2ce641c201eecaddb83ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce706ccba85d5dc14c50cbd7c91dc99ab27489e5d4fb67880da064d4546f88c9"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0d69b382c07d38e432cd49d1f141d2e456e87f31f5d8d4d7674ab2c833dea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ddbb6a01895d449ad69ae591edcb1001c37b549181a1c8daec166c72f4c1d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f480a2f4d778df050f01c6344d9777c8ce2ee729e44694695732ff064050e2a6"
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
