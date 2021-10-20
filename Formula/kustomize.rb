class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.4.0",
      revision: "63ec6bdb3d737a7c66901828c5743656c49b60e1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6708b90a7eb4655101862ea7058171f76a534ee484c20a6748ba6a450a841786"
    sha256 cellar: :any_skip_relocation, big_sur:       "592a5a40ddb3f932ca069d69955adc70c5f0b924814bee9e008fdca0efae7cc2"
    sha256 cellar: :any_skip_relocation, catalina:      "2cc595856f0b60da5387246124b63bb30f8ecae899e6d68901af8c63327b8763"
    sha256 cellar: :any_skip_relocation, mojave:        "299b770815972dbe48d628fca66e1e59733f3581c2552d93829fef6f09569beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459c037953f7a3e6f7c7459af96a1a6707f57d236043582799ba2866b4f36b1d"
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
