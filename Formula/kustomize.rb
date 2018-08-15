class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag => "v1.0.6",
      :revision => "017c4ae0aa19195db2a51ecc5aa82c56a1f1c99b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f64eef42f2f1e2bc6228814c34fa89b981c8b5fcb0944bcc3de48f521f8221" => :high_sierra
    sha256 "9dcf245e8c3f44b9214137f658c672517ce720c73f57cb9d005b96de0654ebc1" => :sierra
    sha256 "a13b5ca673dd8ee8105dd74350d9da517fdb4f931834cc0647c578de7e3c86a2" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip
    tag = Utils.popen_read("git", "describe", "--tags").strip
    dir = buildpath/"src/github.com/kubernetes-sigs/kustomize"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      ldflags = %W[
        -s -X github.com/kubernetes-sigs/kustomize/pkg/commands.kustomizeVersion=#{tag}
        -X github.com/kubernetes-sigs/kustomize/pkg/commands.gitCommit=#{revision}
      ]
      system "go", "install", "-ldflags", ldflags.join(" ")
      bin.install buildpath/"bin/kustomize"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "KustomizeVersion:", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
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
