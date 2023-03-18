class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.0.1",
      revision: "39527da73ca50df19b7678b8f7e87fa94b326296"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8240e28337f11b48add2e899fc1893a7ec8c46a6e62eb98941e22eb1dcce5aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da45710d6bacd2261cd506391f48e1d58312b3d0a39898396dfcc638540eb34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd7c4748678d3a44346e8656bc87dc9408bdbbd6ded92ef69b7cdcd064f225a2"
    sha256 cellar: :any_skip_relocation, ventura:        "b933841feb2e12340b95d5b9bfe5f3ee8a001783fd905a072f4684aea2a49b72"
    sha256 cellar: :any_skip_relocation, monterey:       "e5fe5b4174a5725a507e319c24aca4b67cef56f2be8e9514a425a158e75f4228"
    sha256 cellar: :any_skip_relocation, big_sur:        "47f91442dd2e7ceddb02ae3dd8f4175afa12f272498ae773b6743d02ce4ff6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02409ee9aec6e93430d0e9b169c996f3f340283b21468db224118a515e871910"
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
