class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v3.9.2",
      revision: "e98eada7365fc564c9aba392e954f306a9cbf1dd"
  license "Apache-2.0"
  revision 2
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :head
    regex(%r{kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "20d8e78c76cb8b09d72c519b5ff37424acf2a6db1319d1299695fc93781fa8de" => :big_sur
    sha256 "6b5c93dcc06e20419bad8aa1a6ea6a380c6ded62cf0851faa54e9d1554ed1f64" => :arm64_big_sur
    sha256 "8b04de6df5f60250c57c7eb104bc29a5fa8a9e0b930450799f37f0c2f7fe6355" => :catalina
    sha256 "9ea6e926e0f3fa72516808709311d6786461ac9ec9366dfc9f5cba9e09516864" => :mojave
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_head
    tag = Utils.safe_popen_read("git", "tag", "--contains", "HEAD").strip

    cd "kustomize" do
      ldflags = %W[
        -s
        -X sigs.k8s.io/kustomize/api/provenance.version=#{tag}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{commit}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
    end

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "bash")
    (bash_completion/"kustomize").write output

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "zsh")
    (zsh_completion/"_kustomize").write output

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "fish")
    (fish_completion/"kustomize.fish").write output
  end

  test do
    assert_match "kustomize/v#{version}", shell_output("#{bin}/kustomize version")

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
