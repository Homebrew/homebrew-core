class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.3.0",
      revision: "9da0cf8b4c6bc3bd6d492c66757c89df74d8f63e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da74dc9b70c7d61e1c163778c48e09c93a6e3cc5c192d77529154efcb6cdee79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b874ac704f04ee6377b2cc19e96bcc09cbbd014542c3c942ca5d0e1b2bda8c5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60784086923f8fa0e3e331cb294c287c63af7ed511daad8bc5ecf5d6a0921806"
    sha256 cellar: :any_skip_relocation, sonoma:         "13f1a97c4feea164286cfa272a79d7dc1c379f62cfb5ec4e7de84b536fc6ac2a"
    sha256 cellar: :any_skip_relocation, ventura:        "20782b23f31b14ad44e2bdd45729f1b51e650bed4329c7486a6a40543027b8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "efb4a28bc7353d7f37d8eb89283b08c4fed0581ec9e6e646bdda214088a1d301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073cf7df2aadaaa60767e1dd0672a1bd7dafff56c810a3f59c998e82ba070b9f"
  end

  depends_on "go" => :build

  def install
    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
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
