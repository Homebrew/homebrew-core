class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.6",
      revision: "29ca6935bde25565795e1b4e13ca211c4aa56417"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea453c9787b6f397ff01d089fbd2cccfac4c40d43bf14fe11ca0f1ba8336303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfab4a38897992fb9d93d11a0c25419fa5db5192210450e0acbd89bd58882ac"
    sha256 cellar: :any_skip_relocation, monterey:       "fdcbf55e2f4a3ce77a4fa3a9867097bf0617d4b322ae34ac01ba40ca250aec35"
    sha256 cellar: :any_skip_relocation, big_sur:        "a22d9fbd4cc8f1ea41f7374b20c6962ed1514efb97e421c996772d9b3933cdab"
    sha256 cellar: :any_skip_relocation, catalina:       "a15d4f2f75819f6a7efc1e2d81c02c3aa121393ae0026895c63bb19979a1656f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c68b811ad54c09b9ab70935a69059ec333e4afd53b1d240faf6537c8acfb04"
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
