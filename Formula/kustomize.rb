class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.0.5",
      revision: "9e8e7a7fe99ec9fbf801463e8607928322fc5245"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4623b7c94d76d16b300fe0ff11418340b3e3e1dbde7193b2a5731b95a1855d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a01cb53c12a784dbcc54ea00ce6b35f11f74f4ab10775fe290f7ff3aa51e467c"
    sha256 cellar: :any_skip_relocation, catalina:      "bd17057bcb469a22178063e5a1833618f6bba640076eb8e6769ee23b44b3fbca"
    sha256 cellar: :any_skip_relocation, mojave:        "ac77d0af11db228899fc5a0741dd8b009fba7eb7d0faa4a16e43a1f1693beb1a"
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
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
