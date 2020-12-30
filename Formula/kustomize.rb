class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v3.9.1",
      revision: "7439f1809e5ccd4677ed52be7f98f2ad75122a93"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :head
    regex(%r{kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c8b9a1a407e36111496da037121bcae9a707f6c8a6680b28196e75d50969fe43" => :big_sur
    sha256 "49cc3c5384cc88cc6e1ecd1796434861501672b8b9ce1182d4f7185457ee5679" => :arm64_big_sur
    sha256 "2cbf6ff9f10ed6b8ff107ace2829a6b80d7a393e033a8a80bd2f8c0009cf1a28" => :catalina
    sha256 "9a0c98ec5f41fd92118f74b5769c26db2fd119078297cfee8e6edf8baace8d8e" => :mojave
  end

  depends_on "go" => :build

  def install
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").strip
    tag = Utils.safe_popen_read("git", "tag", "--contains", "HEAD").strip

    cd "kustomize" do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/api/provenance.version=#{tag}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
    end
  end

  test do
    assert_match "kustomize/v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patchesStrategicMerge:
      - patch.yaml
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
    assert_match /type:\s+"?LoadBalancer"?/, output
  end
end
