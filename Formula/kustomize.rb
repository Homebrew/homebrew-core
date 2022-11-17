class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.7",
      revision: "56d82a8378dfc8dc3b3b1085e5a6e67b82966bd7"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8561469b125d99a902b69fab387f1b915d8d11c10ef7f2d7606df8868c7f5f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001f113a50c425d7c0cdbd42461be315b9696dbc89f4d775dce572a87d6cb4ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b573afb3aff29de518a7b60d13dceedf956521a233ee82722cdda4b7fa47e389"
    sha256 cellar: :any_skip_relocation, ventura:        "03b89603a1e329ef55a14cd0eecd6d85493893809254c23ae8d65d283d08def7"
    sha256 cellar: :any_skip_relocation, monterey:       "7878dd7bad7bde751736bac6de721f0e20ba3b75bea81c017105218cf96df369"
    sha256 cellar: :any_skip_relocation, big_sur:        "628577f3b6148a07e7f96b33f2e69d1f778170ed0814a6592b4d32da3ed61266"
    sha256 cellar: :any_skip_relocation, catalina:       "e471ba925c2bb5544a31e1af7eb15cec88b94fc578c902585bf492f240f7bff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18cab0642b06d0f60ed61b4fbca2264e475c1564eeff9f83249cc24ffa1c48ba"
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

    generate_completions_from_executable(bin/"kustomize", "completion")
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
