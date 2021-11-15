class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.4.1",
      revision: "b2d65ddc98e09187a8e38adc27c30bab078c1dbf"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2635754c79a06127bdab258e39b0acf8daf22b84b2611fe8be11a6a72aaaed0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d3f25b6124ec0bbeae608796fb1c31e23ae22bca528720333b9d5945e358a34"
    sha256 cellar: :any_skip_relocation, monterey:       "192d3d4c81f8c487bbf99914ea80a667ef72aa2e39707a6bf634b0c53d4f000b"
    sha256 cellar: :any_skip_relocation, big_sur:        "72db885ba0bb7a5dcebab195f4ab3a9feae6a3caf048345c10454cd2d62393c4"
    sha256 cellar: :any_skip_relocation, catalina:       "d312dd44c71f16a776da83cac77ece3b465b790163ea15cd191271a4baf21ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b657e3e1a442ee5b77af63fda69cdb8e0e0b4b0b46b19d417e952a129ec382aa"
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
      ].join(" ")

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
