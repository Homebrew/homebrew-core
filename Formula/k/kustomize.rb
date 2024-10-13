class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.5.0.tar.gz"
  sha256 "a90ed294c874404934bb5aa132185604d31fbd5622fbcb5ce2c3f56d67eeb322"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a34e6a184939183913d0eb56312afde72e28c22dedf305d9c667efd8a36fceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377f5b7a4eea752d7553084436d07a5ca12898ca26590a9fdc28a6ed67c27e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16acc2a8548c736dc7634b98588c342f8b53a9798174d51e809a4e66bcfbf0b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "93211d48a7837e98bc39e013f7274076799e20b1bf7c1d7480ce10c7c27e0f61"
    sha256 cellar: :any_skip_relocation, ventura:       "6e05b4d3965821a9824a3693c29ee2906720777e867b6336c8144e208bdb217c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc01f68d22e7d2834a0af743eabc3c2f01876816d7dd5a0137977cbb175200f"
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
