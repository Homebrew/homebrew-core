class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.0",
      revision: "67591762a6460f08c589bac325b22049a70c124d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59daa65e16e13cf4e1d8ae5fdefd13bc19e71f0d2387cb1d648639b3f08865c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58c17bd6cc87d717405fcee0604feef66f960727b3c6b2a63a72e83e97c1f7e4"
    sha256 cellar: :any_skip_relocation, monterey:       "830ee10f5d60165ed0f0302785b9e0562b15bf55343b5427f9a166fea7276a48"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7217d308d8597272c63c74fa3f5e8f185bb7b3ada052d2bc1d32b9fb42f5d36"
    sha256 cellar: :any_skip_relocation, catalina:       "127d5944a8c5c34aff07fb9e40bf90cd9f5bc47a5e1130022451951aa83d171f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f04a6ffc03e2066d1489d59acdfc2c9bb367cd20c63a62fe04bf7e7a6453a1"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_head

    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{commit}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
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
