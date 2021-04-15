class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.1.1",
      revision: "7487e2f9cb31cafc796b52a8efa0baeb7c7139d0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88503b60315fcb76c570a84312ead337b6ea002f251afe925aca981781708eb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0fe6967de31e4f41709652d7f8affd599710ca4e360d5bb8b5025c290848494"
    sha256 cellar: :any_skip_relocation, catalina:      "7d06f221b1e5e12203f0daddb03f6dbf349a9765a932c0ccedc2b8522e6f0676"
    sha256 cellar: :any_skip_relocation, mojave:        "1c40ebc9d646d72fbea76763ff9f4613ecaaebe70553447a08b96b3ea174e6dc"
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
