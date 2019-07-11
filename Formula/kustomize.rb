class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v3.0.1",
      :revision => "9bff2e88839145ae0ea6e037b261af9653801974"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b70b5ad313ede9abdeb9c483e957f8ba969a6e47961605dea9aa48a45cd10281" => :mojave
    sha256 "3608bec239fa62e4f39b306c310341e495275c0ac5fc82ac54011955c553096b" => :high_sierra
    sha256 "e406d1b898e6f003a0b07cd326dcc2146e981eda9fb72a47fba4d83d62c05773" => :sierra
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
