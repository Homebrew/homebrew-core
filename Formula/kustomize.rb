class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v2.0.1",
      :revision => "ce7e5ee2c30cc5856fea01fe423cf167f2a2d0c3"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db78fbfff835e28008e5854134c06826bbe324dcf7a18d576fbe71202009b0c6" => :mojave
    sha256 "bf58a993c871de4661840ed3e14f54fb209c7d5e13f54f1416a550b090386ceb" => :high_sierra
    sha256 "ae7033541f451104d58dd597362f32e75ffb6d7c196ac0bf66e9c835d72ed94a" => :sierra
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
        -s -X sigs.k8s.io/kustomize/pkg/commands/misc.kustomizeVersion=#{tag}
        -X sigs.k8s.io/kustomize/pkg/commands/misc.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/pkg/commands/misc.buildDate=#{Time.now.iso8601}
      ]
      system "go", "install", "-ldflags", ldflags.join(" ")
      bin.install buildpath/"bin/kustomize"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "KustomizeVersion:v#{version}", shell_output("#{bin}/kustomize version")

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
