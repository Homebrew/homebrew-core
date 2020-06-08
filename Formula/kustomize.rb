class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "kustomize/v3.6.1",
      :revision => "c97fa946d576eb6ed559f17f2ac43b3b5a8d5dbd"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "418c18672d5b1cd87a7a1df93bbfc1bce26f6e083fdfb6df3b212c233c82f1e4" => :catalina
    sha256 "a2971ecd137bcd53bc20ae1cabbe92894a9f08544778e87aac986e6669b115f4" => :mojave
    sha256 "9a1acdce8261c3f182249491bfb390510a8d8abd451ced366525bbc50f4e5add" => :high_sierra
  end

  depends_on "go" => :build

  def install
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").strip

    cd "kustomize" do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/api/provenance.version=#{version}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kustomize version")

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
