class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.7.1.tar.gz"
  sha256 "9e3907f0ea58426a5a4f64a457e83bbe0a1370ca76048556146f38b52d5fa5f1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef00495b295f7f2b9971263a970035e4f8574c94d74512693d0df20cb405876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c70605462819c8607cd3b3226ca2a3dd7a31686fa1ab0097c84229e1a78b088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020c911d8145c4817b7f4d69bca242a1ad8d50bdde55d9b59e3c543ed637c7dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e5909b666e32b1753e10f24e1ab38f2ccb37722237480ee91cbc8d017e7916c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b146369e6d7f506621816883d733e447ccbaa1fa3d446326343157d62db8803f"
    sha256 cellar: :any_skip_relocation, ventura:       "ec59cb75135c5ce636ba21396e9de164248f62a87954e6d2227105460b6277c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc7f087e8276ba774b5fedf70acf2b52096635aab617ea3fe1985dacde6f8345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97755dbaf7d677c4de963a9546ee8ce6de058b3445dae4e0366c91751ca47bd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
      -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./kustomize"

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~YAML
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    YAML
    (testpath/"patch.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    YAML
    (testpath/"service.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
