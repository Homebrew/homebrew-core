class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "kustomize/v3.2.1",
      :revision => "d89b448c745937f0cf1936162f26a5aac688f840"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e47325d5013a7b05ea444099d3ccd746cd957e17915bd1b54c0187ad02d6d78" => :catalina
    sha256 "a56bc3f26d7526f95467fee01d19da8f8efbe1c795180dff92d2d796f3eb098e" => :mojave
    sha256 "382e90f81114ee7b082c2a211b6d9c380c1a8db5f658d3e5e6fe57ecabe8c746" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip

    dir = buildpath/"src/kubernetes-sigs/kustomize"
    dir.install buildpath.children
    cd dir/"kustomize" do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/kustomize/v3/provenance.version=#{version}
        -X sigs.k8s.io/kustomize/kustomize/v3/provenance.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/kustomize/v3/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
      prefix.install_metafiles
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
