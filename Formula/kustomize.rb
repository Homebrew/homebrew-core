class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v3.1.0",
      :revision => "95f3303493fdea243ae83b767978092396169baf"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97c15af6d0afc923da020d31f533edf398e151af4e928e0877c9c7f125e53df3" => :mojave
    sha256 "8d63266a1f00c964a6b636e4646bba2f222cfab1577f6b2e01bcebb74b657688" => :high_sierra
    sha256 "717113a3fe710bc7b3dc05a5dce085e9a26ac48fda590ae333581c2472150468" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip

    dir = buildpath/"src/kubernetes-sigs/kustomize"
    dir.install buildpath.children
    dir.cd do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.kustomizeVersion=#{version}
        -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize", "cmd/kustomize/main.go"
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
