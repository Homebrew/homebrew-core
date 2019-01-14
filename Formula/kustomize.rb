class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v1.0.11",
      :revision => "8f701a00417a812558a7b785e8354957afa469ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb8ff7ddaa9d038da491acdb44235f607f428c39a80faa8d855afc303f24530" => :mojave
    sha256 "0e27b2962f70aec8432ec69e4102f0c39c6ba11ade93221f10ae4b6833189c77" => :high_sierra
    sha256 "af177ce8c7781711d8857fe987246a88a0f1d86bc42275d4940c6275a05e71be" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip
    tag = Utils.popen_read("git", "describe", "--tags").strip
    dir = buildpath/"src/sigs.k8s.io/kustomize"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/pkg/commands.kustomizeVersion=#{tag}
        -X sigs.k8s.io/kustomize/pkg/commands.gitCommit=#{revision}
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
