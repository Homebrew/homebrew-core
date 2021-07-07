class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.2.0",
      revision: "d53a2ad45d04b0264bcee9e19879437d851cb778"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2aa6e8c3794c5040b9b9825eb20775edef89e9dbd241394fdfe436436dcebedd"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa0f81c67ff35c6ab464eae0d7cbe2542f6c824d957ca9aa873288592d7f802d"
    sha256 cellar: :any_skip_relocation, catalina:      "3de9182e24c05af71c52f786069e4b1642e744c96c8084254114486ea1b09f40"
    sha256 cellar: :any_skip_relocation, mojave:        "301c04e466ebd878cb0c6ea11c275d936dc9ede8d8b9c167419bb6a3c62298f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb394f9b9db714221367626c0d55928ed3ec4c7d91b04adfd0c8847e03f6a80"
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
