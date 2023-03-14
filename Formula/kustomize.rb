class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.0.1",
      revision: "39527da73ca50df19b7678b8f7e87fa94b326296"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec8aa5442404130e05ca86aa6763ef5f5b1e68d4e3a401d4bf27f1d4601b26ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e1da13e90cc74ca2cb206440a9165a02a66887e8a6e3ba2a7f3af365d59fe33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c3ad2955cdcc55f17f40c96c9db739cf42ddb735c556f711194ebb5c8c0490c"
    sha256 cellar: :any_skip_relocation, ventura:        "723f77b3d4dbbedabf3a6a0dc0c4b47bd97bfc184aad5c49e28a85a1918109bb"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe15e163979a389e2ad4449cc18f8c17e004d213a779b93d3e906210b1a7299"
    sha256 cellar: :any_skip_relocation, big_sur:        "220ba0405fae3db86b305b43c3e0d1ef23a11f9c153b5b8b15d44e9280064b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e894ddff0c86c0dad0f333a4e70233cac74d513604c74dd324862111379c61c1"
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
