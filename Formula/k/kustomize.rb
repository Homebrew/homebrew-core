class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.1.1",
      revision: "f8391994b4dc1558fa25596d41311fde07f96e46"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d3df950a0352258701e77d77733cbd0d515576dc4a54897a2035a985c6c86ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb341d323479c9e47006daed35dfff4a30210df230bf2329b36ed85c5f4f2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922c53c719dba7cd3863a5508af03b466d34fea3aed14a299dad0c6784872fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f892731c66c44d3811b45fe235804089ab62fe2d40e4c3f743152b80e97f82f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4708d3af08069beb0a5a450c18ebbe4fa36075a38cc26a087bec0283d7f80dfc"
    sha256 cellar: :any_skip_relocation, ventura:        "ee5b223fd99f51952fa37730384bf9771e1ef911f5f683181c2ef4415ec42a2d"
    sha256 cellar: :any_skip_relocation, monterey:       "4042cf364407b01e6f298f94b4ce1bb7a9ed395a272b622fd0c71145bccc088b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fc392427a0e9a7aec0bdf644f6b07fe8fca31715266c706a007b55e6b5b9407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "481bf7f7a5993db3ddafc1d986fdaa78e1960896ca77469f21d9f8df76ec8637"
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
