class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.0.2",
      revision: "ccdc148472a86f50bcb1e24fdc137f0d784bebb5"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bb3d50ec9299afc75d32616eb490b154f7b5755bf5e0954544c38443328c6d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80404c0ebaeb8dc6b534ac51dba3bcaf240adf09a8f78a3e8ff8ecc9e42702e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc0ca6537fbe74be1c6a94f53750378ce872de69ee3cc577b27deef1dab4dded"
    sha256 cellar: :any_skip_relocation, ventura:        "214f15755a39ee69574f5e46812f76a3f374e4e58837e8ae8f1025a160a9490c"
    sha256 cellar: :any_skip_relocation, monterey:       "b5d8cee6ffa2c105e6e4e73d2e4933b851e9513fc8ce76523d3fff32081c8b3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d10b1cce0aac85a384fcbc04385013b503532c301433424ce30484594ca50fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50b13be3c93098f2df1bfcc8aca4f945cf086e9c7d6200d514c628beebce2fc"
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
