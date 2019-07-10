class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v3.0.1",
      :revision => "9bff2e88839145ae0ea6e037b261af9653801974"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e63f86c83cfd874cec94cec2536ebf675b03deb72a23ad30e7d3c3273460196c" => :mojave
    sha256 "50e54e50c2af4c050389953415148441fe70fac8faa89d8618577e0a4b0d404b" => :high_sierra
    sha256 "e0f544ccdfc837ca192852526504c8e7b46a0c14b708b4a36f6c35c3e6750924" => :sierra
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
