class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.4.3.tar.gz"
  sha256 "911e749de8d33a35ebeff50f65d0c3d79e5d1c9ff7eb9b73e29192d99b5f2444"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e6d222e8a5e9bd13ae418db39804da9a84a21fcb291683d5223abe70e9f4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f0377cccfda2718997ac62aa1e7c727e7ad979717d54a1cef793547fc15a23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f682df029c1aa5c463951322c80020b0ba75c1414044af032842b3618c826a"
    sha256 cellar: :any_skip_relocation, sonoma:         "488be64e3439c71b80eecafa30728c79e71287cb0acc3ab7474020656cf954a2"
    sha256 cellar: :any_skip_relocation, ventura:        "d615f46ca90a431045476fb26a555ad77807fd347033165f146567d445b9b70c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4649044fed586e0a8a58ae4add96b9d0cfc99a64ab73134f18b749f847fce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c71cc051fa36e9fa7abd46ad8076e07dfc0cb8b102cb7e048bca437c885c6ac"
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
