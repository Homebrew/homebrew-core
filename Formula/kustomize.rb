class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.4",
      revision: "cf3a452ddd6f83945d39d582243b8592ec627ae3"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e71b026ffe77f221673bbc6306bff8fbf6d617b67c21b1f29195c17773c6de53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f02fef6fb488fd30f9db2529837ca08a656037e34100204ece081dde5a371e1"
    sha256 cellar: :any_skip_relocation, monterey:       "1535062dcc42e6776f9506e12e572e19a5c18017543ece5be92e7c770b53490a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c3123f5999d95c8d7f9c2ff3863381c4b9f0f506a1243ad833c7b903281e997"
    sha256 cellar: :any_skip_relocation, catalina:       "5e68d3577bd2e37f1fb76cb385735553b04e338c36a979dfa01dfaaa91cecb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db74e716a83a2b82b6c4d9477be3f0f600b7b7dac397e4a07b29b11352429b3"
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
