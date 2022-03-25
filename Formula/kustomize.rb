class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.3",
      revision: "de6b9784912a5c1df309e6ae9152b962be4eba47"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87456804bc75e7ab4d2ea7ef9d31999a22bc76de4c106cf4535a8db986e3d14c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d58b8be4573ee7c2050a53e1aaebc0e7f0675edee20b47b5dec77265bf562fc"
    sha256 cellar: :any_skip_relocation, monterey:       "5acd4796b79e0833e7c38fcf3c36472e5717161d79417dddf18fe37a0db4520d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf0ac2db5463aecb28300a46c9f051c8b58a379c4bed499f1c7faef33fbfdd1"
    sha256 cellar: :any_skip_relocation, catalina:       "7010c3fac508424d2b6fc30e9024a97fecbf6661a81ad5ff3ae1a421ee449f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228f9f22e9af24cd392a4e527fa6ca578403d174560dea62c27c9df81b070cc2"
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
