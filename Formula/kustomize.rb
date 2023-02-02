class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.0.0",
      revision: "738ca56ccd511a5fcd57b958d6d2019d5b7f2091"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48df57d4281e077b1dfa44f7441127cedecde8077412072ad9d4c0146574771a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a0af84510d228e903512a8cc391174d5dd4aef2b863bd28d15154a762284bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ba7bdec85bcd185a15ef3a56744afea3a8f312c59096b2d27f75277f95be8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "138e095b13981dacea43cbbd90b434f91cd393d32a69601c2aa6e24a036047db"
    sha256 cellar: :any_skip_relocation, monterey:       "56852516f12b449adc2022b054ab164aa1b8fd779bd563093e144959482f5540"
    sha256 cellar: :any_skip_relocation, big_sur:        "65e1bcbb39950da245feb34c8f4521c5786e59fdb8e3fdc3ff2057cba1917274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06818973a53e46a0534b8f4b0fb04554d0ec1b0d98758421983b0539b6767403"
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
