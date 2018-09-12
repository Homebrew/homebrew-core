class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag => "v1.0.7",
      :revision => "633c43a672715dc4c39eaa983a8886ecd21be2e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1af029177ee6dd8d7774a46a488d86391b6ae9b50c6a16b1f16e4ed47ddd9f3" => :mojave
    sha256 "6e6c6c03ac7c01d6b54538ed03e80e22d7ebda6c0c884b70d5c59bf08293a0fa" => :high_sierra
    sha256 "a7732aeef73e50bef5c9ae8a56f21b49c16280798070578ba6bb111ed6d6cd02" => :sierra
    sha256 "8a93a58c2eba1cfae70ac71cdbb350012eb307a75ac770551245d5639e05cc55" => :el_capitan
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
