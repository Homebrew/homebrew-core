class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v3.2.0",
      :revision => "a3103f1e62ddb5b696daa3fd359bb6f2e8333b49"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37e844f32fe59d3e8fd770d2c0270573d05569989a4f1ff681f5bc52064461cd" => :mojave
    sha256 "c4394c1616de83613db73580e3aaa2667592d726803ee0fa247acd47e8d6034b" => :high_sierra
    sha256 "5fb657f255f45d45e2aa9ecfc5cee7d2af20344b184dfbe46a1ceb1105cb4cee" => :sierra
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
