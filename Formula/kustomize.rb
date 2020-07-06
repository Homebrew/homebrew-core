class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "kustomize/v3.8.0",
      :revision => "6a50372dd5686df22750b0c729adaf369fbf193c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7cb7a07b3c3e2740178700b024f17a8c1bd93d99a4ddb253dcd24c5d077ab11" => :catalina
    sha256 "a52447ddab6a6120c585a3b655d17547103db00e227a6a6350c5488ef6c19f5c" => :mojave
    sha256 "45c4afd89bf791b35a260639408090d680a7384eac0567ec343532ff2138a5d7" => :high_sierra
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
