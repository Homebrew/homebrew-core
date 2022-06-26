class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.5",
      revision: "daa3e5e2c2d3a4b8c94021a7384bfb06734bcd26"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5919e64168ab4a65cbf976b65215849c7a5d9b71ce8f9f57ea89d3b7d7aea65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f337db7acba53a1066073f8f05bb3fd24cbf15beb90f9ee4d3458ba89b815716"
    sha256 cellar: :any_skip_relocation, monterey:       "d8cba8c955b392279f9a95be294d8c005ccfb3dc98b2ea87d8633dea04e1ec63"
    sha256 cellar: :any_skip_relocation, big_sur:        "61942059da88f6e67803118f4c7b4918ac51e540592c5e337717d1b303bdb2cd"
    sha256 cellar: :any_skip_relocation, catalina:       "80c0830923dd4515686eb0cd5c5288844b9c845febcb5cece85b4a9f3ec78d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b422cba0c7950fdb51513875404fe5f01398621a2d11a9a08750c2df27f49fb"
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
